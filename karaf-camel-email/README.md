# Sending e-mail with attachments

## Environment

- Apache Karaf 4.4.11
- Apache Camel 4.18.1
- jakarta
- Java 21

## Install and Set Java Runtime

export JAVA_HOME=/usr/lib/jvm/temurin-21-jre-amd64

## Install Karaf

- unpack Karaf into KARAF_HOME
- test run
```
bin/karaf
```

## Install Camel

Version LTS is 4.10.3
```
feature:repo-add camel 4.18.1
feature:install camel-mail camel-blueprint camel-groovy
```
## Blueprint for sending e-mail

```
<?xml version="1.0" encoding="UTF-8"?>
<blueprint xmlns="http://www.osgi.org/xmlns/blueprint/v1.0.0"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="
             http://www.osgi.org/xmlns/blueprint/v1.0.0 https://www.osgi.org/xmlns/blueprint/v1.0.0/blueprint.xsd
  http://camel.apache.org/schema/blueprint http://camel.apache.org/schema/blueprint/camel-blueprint.xsd">

  <!-- import org.eclipse.angus.mail.handlers -->
  <manifest xmlns="http://karaf.apache.org/xmlns/deployer/blueprint/v1.0.0">
    Import-Package = org.eclipse.angus.mail.handlers
  </manifest>
    <camelContext id="file-to-smtp-context" xmlns="http://camel.apache.org/schema/blueprint">
        <route id="file-to-email-route">
            <!-- 1. Monitor the 'in' directory for new files -->
            <from uri="file:in?delete=true&amp;noop=false"/>
            <!-- 2. Prepare Email Headers -->
            <setHeader name="To">
                <constant>name.name@gmail.com</constant>
            </setHeader>
            <setHeader name="From">
                <constant>name@pri.ee</constant>
            </setHeader>
            <setHeader name="Subject">
                <simple>File processed: ${file:name}</simple>
            </setHeader>

            <!-- 3. Move file body into mail attachment using inline Groovy scripting -->
            <script>
                <groovy>
                    import org.apache.camel.attachment.AttachmentMessage
                    import jakarta.activation.DataHandler
                    import jakarta.mail.util.ByteArrayDataSource

		    import jakarta.activation.CommandMap;
		    import jakarta.activation.MailcapCommandMap;

		    /* This is important to have, otherwise no handler for multipart/mixed is found. */
		    MailcapCommandMap mc = (MailcapCommandMap) CommandMap.getDefaultCommandMap();
		    mc.addMailcap("multipart/*;; x-java-content-handler=org.eclipse.angus.mail.handlers.multipart_mixed");
		    mc.addMailcap("text/plain;; x-java-content-handler=org.eclipse.angus.mail.handlers.text_plain");
		    CommandMap.setDefaultCommandMap(mc);
		    
                    // Access Camel's Attachment Facade
                    def attMsg = exchange.getMessage(AttachmentMessage.class)
                    
                    // Read file content and original filename
                    byte[] fileBytes = exchange.getIn().getBody(byte[].class)
                    String fileName = exchange.getIn().getHeader("CamelFileName", String.class)
                    
                    // Bind content as attachment data source
                    def dataSource = new ByteArrayDataSource(fileBytes, "application/octet-stream")
                    attMsg.addAttachment(fileName, new DataHandler(dataSource))
                </groovy>
	    </script>

            <!-- 4. Set the text message body for the email -->
            <setBody>
                <simple>Hello,\n\nPlease find the attached file: ${file:name}.</simple>
            </setBody>

	    <convertBodyTo type="String"/>
	    
            <!-- 5. Send over SMTP (Adjust port, user, and password properties accordingly) -->
            <to uri="smtp://smtp.zone.eu:587?mail.smtp.starttls.enable=true&amp;username=name@pri.ee&amp;password=........&amp;mail.smtp.auth=true"/>
            
            <log message="Successfully sent file ${file:name} as email attachment to name.name@gmail.com"/>
        </route>
        
    </camelContext>

</blueprint>
```
