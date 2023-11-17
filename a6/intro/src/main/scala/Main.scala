import java.util.concurrent.atomic.AtomicInteger
@main def hello: Unit =
  println("Hello world!")
  val arr = generateArray()
  println(arr.mkString(",")) // array with values 1-50
  println(sumArray(arr)) // sums all values in array 1-50
  println(sumArrayRecursive(arr)) // sums all values in array 1-50 recursively
  println(fib(10)) // nth fibonachi number
  val t = getThread(() => println("Hello from some thread"))
  t.start()
  t.join()

  val t1 = getThread(increaseCounter)
  val t2 = getThread(increaseCounter)
  val t3 = getThread(printCounter)
  t1.start()
  t2.start()
  t3.start()

/*Scala Introduction */
//a)
def generateArray(): Array[Int] = 
  var arr:Array[Int] = new Array[Int](50)
  for (i <- 0 to arr.length-1) {
    arr(i) = i + 1
  }
  arr

//b)
val sumArray: Array[Int] => Int = (arr: Array[Int]) => {
    var sum = 0
    for (i <- 0 to arr.length-1) {
      sum += arr(i)
    }
    sum
  }
  
//c)
val sumArrayRecursive: Array[Int] => Int = (arr: Array[Int]) => {
  if (arr.length == 0) {
    0
  } else {
    arr(0) + sumArrayRecursive(arr.drop(1))
  }
}

//d), BigInt has efficient encoding of arbitrary integers while Int has maximum 32 bits to represent an integer
val fib: BigInt => BigInt = (nth: BigInt) => {
  if (nth <= 1) nth
  else fib(nth - 1) + fib(nth - 2)
}

/*Mutable or Immutable*/
//var is mutable and val is immutable

/*Concurrency in Scala*/
//a)
val getThread = (func: () => Unit) => {
  new Thread(new Runnable{
    override def run(): Unit = {
      //println("Printing function value from thread: "+func()) // The function is run when the thread is started
      func()
    }
  })
}

//b) 
/*
  Evreytime the printCounter resulted in 2 on my PC, but that may not always be the case due to
  concurrency and scheduling issues. We don't know how schedulers work, which means there is no
  guarantee that we know in which order threads will execute. This may be problematic when the
  order of operations are important e.g. when assembling something. Imagine a system that runs
  a set of robots, where each robots code is executed in a unique thread, and these robots assemble
  cars. If the robots that put on the doors start execution before the one that puts on the chassis,
  it will lead to problems.
*/
private var counter: AtomicInteger = new AtomicInteger(0)
def increaseCounter(): Unit = {
  counter.incrementAndGet()
  //counter.set(counter.get() + 1)
}
def printCounter(): Unit = {
  println("printing counter: " + counter.intValue())
}


//c)
/*
  By setting the counter to be of type AtomicRefernce, it should provide ownership of the 
  variable and ultimately remove the problem of concurrency as per https://twitter.github.io/scala_school/concurrency.html.
*/