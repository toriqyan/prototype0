
from twilio.rest import TwilioRestClient
import tweepy, time, sys
import pyttsx

number = ""
with open("myspeech.txt", "r") as ins:
	array = []
	for line in ins:
		array.append(line)
recipient = array[0].lower().rstrip()
message = array[1]

directory = {
	"chris": "+12063512403",
	"sayna": "+12068546608",
	"tori": "+12062901183",
}

# Your Account Sid and Auth Token from twilio.com/user/account
account_sid = "AC2d4a9a06d880759331af9c996522e039"
auth_token  = "79f07659e30050dcaeb99b7ca397f5d4"
client = TwilioRestClient(account_sid, auth_token)

def send_message(number, message):
	message = client.messages.create(body=message,
	    to=number,    # Replace with your phone number
	    from_="+12156420675") # Replace with your Twilio number
	print "message sent"
	print message.sid

def feedback():
	engine = pyttsx.init()
	engine.setProperty('rate', 110)
	voices = engine.getProperty('voices')
	engine.setProperty('voice', "english-scottish")
	engine.say("Message Sent")
	engine.runAndWait()

def tweet(message):
	CONSUMER_KEY = "4zh0yNbhw61ipVX7zMnqMCL4C"
	CONSUMER_SECRET = "cRri6TCw9E7xHmb5TL7VWrgsEeV9SCvN92TxONfp2mub818Ptc"
	ACCESS_KEY = "3258448136-yMD1Ihz7OXxiGmv7UUrXBuTYmv9mq6gdQef7q2y"
	ACCESS_SECRET = "GGS6BIVZQStOOf3V5wI5mrhfqJfK6mjw9lhJp0ikvgJtK"
	auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
	auth.set_access_token(ACCESS_KEY, ACCESS_SECRET)
	api = tweepy.API(auth)
	api.update_status(status=message)

def output(number, message, directory, recipient):
	if recipient in directory:
		number = directory[recipient]
		if len(message) > 0 :
			send_message(number, message)
			tweet(message)
			feedback()
		else:
			message = "No message recorded"
			send_message(number, message)
			tweet(message)
			feedback()
	else:
		send_message(directory["sayna"], message)
		tweet(message)
		feedback()
		print recipient

output(number, message, directory, recipient)


