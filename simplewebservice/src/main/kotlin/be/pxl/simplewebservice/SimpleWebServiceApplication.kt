package be.pxl.simplewebservice

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.GetMapping

@SpringBootApplication
class SimpleWebServiceApplication

fun main(args: Array<String>) {
	runApplication<SimpleWebServiceApplication>(*args)
}

@RestController
class MessageResource {
	@GetMapping
	fun index(): List<Message> = listOf(
		Message("1", "Hello PXL!"),
		Message("2", "Bonjour PXL!"),
		Message("3", "Merhaba PXL!"),
		Message("4", "Privet PXL!"),
	)
}

data class Message(val id: String?, val text: String)