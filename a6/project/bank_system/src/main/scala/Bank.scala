import collection.mutable.Map
import java.util.UUID

class Bank(val allowedAttempts: Integer = 3) {

    private val accountsRegistry : Map[String,Account] = Map()

    val transactionsPool: TransactionPool = new TransactionPool()
    val completedTransactions: TransactionPool = new TransactionPool()


    def processing : Boolean = !transactionsPool.isEmpty

    // TODO
    // Adds a new transaction for the transfer to the transaction pool
    def transfer(from: String, to: String, amount: Double): Unit = {        
        val newTransaction = new Transaction(from, to, amount)
        transactionsPool.add(newTransaction)
    }

    // TODO
    // Process the transactions in the transaction pool
    // The implementation needs to be completed and possibly fixed
    def processTransactions: Unit = {

        val workers : List[Thread] = transactionsPool.iterator.toList
                                                .filter(t => t.getStatus() == TransactionStatus.PENDING)
                                                .map(processSingleTransaction)

        workers.map( element => element.start() )
        workers.map( element => element.join() )

        /* TODO: change to select only transactions that succeeded */
        val succeded : List[Transaction] = transactionsPool.iterator.toList
                                                        .filter(t => t.getStatus() == TransactionStatus.SUCCESS)


        /* TODO: change to select only transactions that failed */
        val failed : List[Transaction] = transactionsPool.iterator.toList
                                                        .filter(t => t.getStatus() == TransactionStatus.FAILED)


        succeded.map(t => transactionsPool.remove(t)) //Remove successfull transactions from transactionPool
        succeded.map(t => completedTransactions.add(t)) //Add successfull transactions to completedTransactions

        failed.map(t => { 
            /*  transactions that failed need to be set as pending again; 
                if the number of retry has exceeded they also need to be removed from
                the transaction pool and to be added to the queue of completed transactions */
            if (t.exceeded()) {
                transactionsPool.remove(t)
                completedTransactions.add(t)
            } else {
                t.setStatus(TransactionStatus.PENDING)
            }
        })

        if(!transactionsPool.isEmpty) {
            processTransactions
        }
    }

    // TODO
    // The function creates a new thread ready to process
    // the transaction, and returns it as a return value
    private def processSingleTransaction(t : Transaction) : Thread =  {
        new Thread(new Runnable{
            override def run(): Unit = {
                t.attempting() //Attempting the transaction, updating counter here

                if (t.getStatus() == TransactionStatus.PENDING) { //If status is pending, try transfer
                    val a1Option = getAccount(t.from) //Try getting from account
                    a1Option match {
                        case Some(a1) => {
                            val a2Option = getAccount(t.to) //Try getting to account
                            a2Option match {
                                case Some(a2) => {

                                    //Both accounts are here, need to withdraw from a1 and deposit to a2
                                    val a1Either = a1.withdraw(t.amount)
                                    a1Either match {
                                        case Right(newA1) => {
                                            val a2Either = a2.deposit(t.amount)

                                            a2Either match {
                                                case Right(newA2) => {
                                                    this.synchronized { //NB! need the update of the accounts to be thread safe too
                                                    //Both transactions went through, updating accounts
                                                    accountsRegistry.update(newA1.code, newA1)
                                                    accountsRegistry.update(newA2.code, newA2)

                                                    //Also set the transaction status 
                                                    t.setStatus(TransactionStatus.SUCCESS)
                                                    }

                                                }
                                                case Left(error) => { 
                                                    t.setStatus(TransactionStatus.FAILED)
                                                    println("Could not perform deposit: " + error)
                                                }
                                            }
                                                
                                        }
                                        case Left(error) => { 
                                            t.setStatus(TransactionStatus.FAILED)
                                            println("Could not perform withdrawl: " + error)
                                        }
                                    }
                                } 
                                case None =>{ 
                                    t.setStatus(TransactionStatus.FAILED)
                                    println("No such account: " + t.to)
                                }
                            }
                        }
                        case None => {
                            t.setStatus(TransactionStatus.FAILED)
                            println("No such account: " + t.from)
                        }
                    }
                } 
            }
        })
    }


    // TODO
    // Creates a new account and returns its code to the user.
    // The account is stored in the local registry of bank accounts.
    def createAccount(initialBalance: Double) : String = {
        val code = UUID.randomUUID().toString()
        accountsRegistry.put(code, new Account(code, initialBalance))
        code
    }


    // TODO
    // Return information about a certain account based on its code.
    // Remember to handle the case in which the account does not exist
    def getAccount(code : String) : Option[Account] = {
        accountsRegistry.get(code)
    }
}
