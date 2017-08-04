Issues in Live Video Screen
1. "Send" on comment screen crashes app
2. Dummy Data on Live Video Details page
3. Like Button not working
4. Shows video even if it's not live (due to interuption)


Model:
NewsFeed
{
	"id": <newsFeedID>,
	"actionUserID" : <userID>,
	"actionUserName": <userName>,
	"participantUserID" : <userID>,
	"participantUserName": <userName>,
	"redirectID": <id>,
	"redirectPath": <classPath>,
	"activity": <activityName>,
	"text": "",
	"createdAt": <timeStamp>,
	"mediaURL": <mediaURL>,
	"likes": {
		<userID>: <bool>
	},
	"comments" : {
		<commentsID>: {
			"id": <commentsID>,
			"user": {
				"id": <userID>,
				"name": <userName>
			},
			"refrenceID": <refrenceID>,
			"text": "",
			"createdAt": <timeStamp>
			}
		}

}