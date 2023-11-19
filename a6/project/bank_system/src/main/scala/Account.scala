
class Account(val code : String, val balance: Double) {

    // TODO
    // Implement functions. Account should be immutable.
    // Change return type to the appropriate one
    def withdraw(amount: Double) : Either[String, Account] = {
        if (amount < 0 || amount > balance) return Left("Invalid amount in withdraw")
        else return Right(new Account(code, balance-amount))
    }

    def deposit (amount: Double) : Either[String, Account] = {
        if (amount < 0) return Left("Invalid aomunt in deposit")
        else return Right(new Account(code, balance+amount))
    }

}
