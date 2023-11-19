import java.util.concurrent.atomic.AtomicReference
import scala.collection.mutable.ArrayBuffer
object TransactionStatus extends Enumeration {
  val SUCCESS, PENDING, FAILED = Value
}

class TransactionPool {
    var transactions: AtomicReference[ArrayBuffer[Transaction]] = new AtomicReference[ArrayBuffer[Transaction]](ArrayBuffer.empty[Transaction]) 

     // Remove and the transaction from the pool
    def remove(t: Transaction): Boolean = {
      this.synchronized {
        val prevSize = size
        transactions.get() -= t
        val newSize = size
        prevSize - newSize == 1
      }
    }

    // Return whether the queue is empty
    def isEmpty: Boolean = {
      transactions.get().isEmpty
    }

    // Return the size of the pool
    def size: Integer = {
      transactions.get().size
    }

    // Add new element to the back of the queue
    def add(t: Transaction): Boolean = {
      this.synchronized {
        val prevSize = size
        transactions.get() += t
        val newSize = size
        newSize - prevSize == 1
      }
    }

    // Return an iterator to allow you to iterate over the queue
    def iterator : Iterator[Transaction] = {
      transactions.get().iterator
    }

}

class Transaction(val from: String,
                  val to: String,
                  val amount: Double,
                  val retries: Int = 3) {

  private var status: TransactionStatus.Value = TransactionStatus.PENDING
  private var attempts = 0

  def getStatus() = status

  // TODO: Implement methods that change the status of the transaction
  def setStatus(newStatus: TransactionStatus.Value) = {
    status = newStatus
  }

  def attempting() = {
    attempts = attempts + 1 
  }

  def exceeded(): Boolean = {
    attempts > 3
  }
}
