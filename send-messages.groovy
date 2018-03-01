@Grab(group = 'com.rabbitmq', module = 'amqp-client', version = "5.1.2")
@Grab(group = 'org.slf4j', module = 'slf4j-simple', version = '1.7.25')
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

ConnectionFactory cf = new ConnectionFactory();
cf.setUsername("admin");
cf.setPassword("admin");
cf.setHost("localhost");
cf.setRequestedHeartbeat(5);

Connection c = cf.newConnection("large-sender");

AtomicInteger count = new AtomicInteger(0);
Executors.newScheduledThreadPool(10).scheduleAtFixedRate(
  { -> 
    System.out.println("Sending " + Thread.currentThread());
    Channel ch = null;
    try {
      ch = c.createChannel();
      ch.confirmSelect();
      long start = System.currentTimeMillis();

      ch.basicPublish("", "shovel-source", null, new byte[50_000_000]);

      ch.waitForConfirms();
      ch.close();
      System.out.println("Confirmed in " + (System.currentTimeMillis() - start) + " ms");
      System.out.println("Sent: " + count.incrementAndGet());
    } catch (Exception e) {
      e.printStackTrace();
    }
  }, 0, 5, TimeUnit.MINUTES);

CountDownLatch latch = new CountDownLatch(1);
latch.await();
c.close();
