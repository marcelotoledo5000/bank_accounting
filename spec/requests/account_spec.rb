# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsController', type: :request do
  describe 'POST /accounts' do
    let(:user) { create(:user) }
    let(:valid_params) { { user_id: user.id } }

    context 'when the request is valid' do
      let(:account) { User.find(user.id).account }

      before do
        post accounts_path,
             params: valid_params,
             headers: basic_credentials(user.cpf, user.password)
      end

      it 'creates an account' do
        expect(response).to have_http_status :created
        expect(json).not_to be_empty
        expect(json[:id]).to eq account.id
        expect(json[:user_id]).to eq user.id
        expect(Account.last.current_balance).to eq 0.0
      end
    end

    context 'when the request is invalid' do
      before do
        post accounts_path,
             headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns status code 422' do
        expect(response).to have_http_status :unprocessable_entity
        expect(json).not_to be_empty
      end
    end

    context 'when the user is unauthorized' do
      before do
        post accounts_path,
             params: valid_params,
             headers: basic_credentials('user@email.com', '00000000')
      end

      it 'returns status code 401' do
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'GET /accounts/:id' do
    let(:user) { create(:user) }

    context 'when the record exists' do
      let(:account) { create(:account, user: user) }

      before do
        get account_path(account.id),
            headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns the account' do
        expect(json).not_to be_empty
        expect(json[:id]).to eq account.id
      end

      it 'returns status code 200' do
        expect(response).to have_http_status :ok
      end
    end

    context 'when the record does not exist' do
      before do
        get account_path(100),
            headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns status code 404' do
        expect(response).to have_http_status :not_found
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Account/)
      end
    end
  end

  describe 'GET /balance' do
    context 'when accounts starting with zero balance' do
      let(:user) { create(:user) }
      let(:account) { create(:account_with_transaction, user: user) }

      before do
        get balance_path,
            params: { id: account.id },
            headers: basic_credentials(user.cpf, user.password)
      end

      it do
        expect(response).to have_http_status :ok
        expect(json).to eq 0.0
      end
    end
  end

  describe 'GET /statement' do
    context 'when access statement' do
      let(:user) { create(:user) }
      let(:account) { create(:account_with_transaction, user: user) }
      let(:transaction) { create(:transaction, account: account) }
      let(:balance) do
        (account.transactions.first.amount + transaction.amount).to_f
      end
      let(:statement) do
        [
          {
            date: account.transactions.first.created_at.utc,
            document: "##{account.id}##{account.transactions.first.id}",
            description: account.transactions.first.description,
            kind: account.transactions.first.kind,
            amount: account.transactions.first.amount.to_f
          },
          {
            date: transaction.created_at.utc,
            document: "##{account.id}##{transaction.id}",
            description: transaction.description,
            kind: transaction.kind,
            amount: transaction.amount.to_f
          }
        ]
      end

      before do
        statement
        get statement_path,
            params: { id: account.id },
            headers: basic_credentials(user.cpf, user.password)
      end

      it { expect(response.body).to eq statement.to_json }
      it { expect(account.current_balance).to eq balance }
    end
  end
end
