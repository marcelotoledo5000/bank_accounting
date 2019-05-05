class AccountService
  def self.balance_initial(account_id)
    Transaction.create!(
      account_id: account_id, kind: 'credit', value: 0, balance: 0
    )
  end
end
