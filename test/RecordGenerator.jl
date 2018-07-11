"""
RecordGenerator

This is a compact little record generator; It simply does that.
It is a birds nest of ternarys and rand indexing, yes. It works is not a valid defense...
but it works. Can be expanded to include any kind of record type. Will work on making pretty sometime
(ie moving everything out of the returns and so many nested ternarys)
"""

#(I know the vars are not properly cased)
const boyFirstNamePool = ["Michael", "John", "Evan", "Steven", "Peter", "Robert", "Paul", "Matthew", "Mark", "Luke",
					     "Jose", "Raul", "Andrew", "Anthony", "Eric", "Samuel", "Daniel", "Malcom", "Sam", "Thomas",
					     "David", "Damien", "Lucas", "Cory", "Theodore", "Justin", "Gregory", "George", "Alexander", "Henry", 
					     "Brian", "Jimmy", "Frank", "Arthur", "Manuel", "Muhammed", "Toby", "Kevin", "Tim", "Kenneth"]

const girlFirstNamePool = ["Lisa", "Anne", "Marie", "Carol", "Samantha", "Catherine", "Susan", "Sarah", "Nicole", "Tina",
				   		  "Lupe", "Erica", "Jennifer", "Mary", "Emma", "Bethany", "Megan", "Alexia", "Alicia", "Kelly",
				   		  "Midge", "Stephanie", "Patricia", "Linda", "Barbera", "Elizabeth", "Margaret", "Dorothy", "Nancy", "Karen", 
				   		  "Betty", "Helen", "Sandra", "Donna", "Joan", "Judith", "Tammy", "Charlotte", "Kara", "Cheryl"]

const lastNamePool = ["Smith", "Jones", "Brown", "Johnson", "Williams", "Miller", "Taylor", "Wilson", "Davis", "White",
				     "Clark", "Hall", "Thomas", "Thompson", "Moore", "Hill", "Walker", "Anderson", "Wright", "Martin",
				     "Wood", "Allen", "Robinson", "Lewis", "Scott", "Young", "Jackson", "Adams", "Tryniski", "Green",
				     "Evans", "King", "Baker", "John", "Harris", "Roberts", "Campbell", "James", "Stewart", "Lee",
				     "Morris", "Turner", "Parker", "Cook", "Edwards", "Mitchell", "Bell", "Ward", "Watson", "Morgan",
				     "Lee", "Kim", "Patel", "Nguyen", "Chen", "Wong", "Li", "Park", "Lin", "Yang"]

const rhodeIslandCities = (("Providence", "Warwick", "Cranston", "Pawtucket", "East Providence", "Woonsocket", 
						   "Coventry", "Cumberland", "North Providence", "South Kingstown", "West Warwick", "Johnston",
						   "West Greenwich", "East Greenwich", "North Kingstown", "Smithfield", "Central Falls", "Bristol", 
						   "Scituate", "Foster"), "RI")

const massCities = (("Boston", "Worcester", "Springfield", "Lowell", "Cambridge", "New Bedford", 
				    "Brockton", "Quincy", "Lynn", "Fall River", "Newton", "Lawrence",
				    "Somerville", "Framingham", "Haverhill", "Waltham"), "MA")

const streets = (("Second", "Third", "Fourth", "Park", "Fifth", "Main",
				 "Sixth", "Oak", "Seventh", "Pine", "Maple", "Cedar",
				 "Eigth", "Elm", "View", "Washington", "Ninth", "Lake",
				 "Washington", "Hill", "Pleasent", "Highland", "Davol", "Cross",
				 "Elmwood", "King", "Post", "Easton", "Evergreen Terrace", "34th"),
			  	("St.", "Rd.", "Ave.", "Blvd.","Ln.", "Sq."))

const emailProviders = ("gmail.com", "brown.edu", "ccri.edu", "aol.com", "hotmail.com", 
					   "msn.com", "outlook.com", "yahoo.com", "iCloud.com", "mail.com")

const avgMaleHeight = 175.7; const avgFemaleHeight= 161.8	#in kg
const avgMaleWeight = 88.8;  const avgFemaleWeight= 76.4		#in cm

#Grabs a name from the list depending on gender.
function fname_generator(gender)
	return (gender==1 ? boyFirstNamePool[rand(UInt8)%length(boyFirstNamePool)+1] : girlFirstNamePool[rand(UInt8)%length(girlFirstNamePool)+1])
end

#Grabs a name from the list
function lname_generator()
	return lastNamePool[rand(UInt8)%length(lastNamePool)+1]
end

#Makes a weight/height for a human of a given gender.
function body_generator(gender)
	randWeight = mod(rand(Int8),(gender==1?100:80))
	return ((gender==1 ? avgMaleWeight + (randWeight<-20 ? (-(mod(rand(UInt8),30))) : randWeight) : avgFemaleWeight + (randWeight < -20 ? (-(mod(rand(UInt8),30))) : randWeight)), (gender==1? avgMaleHeight + (mod(rand(Int8),60)) : avgFemaleHeight + (mod(rand(Int8),60))))
end

#Makes up an age, and spits back a semi-accurate dob.
function age_generator(curMonth)
	#get age + dob
	age = (rand(UInt8)%100)+1
	bMonth = (rand(UInt8)%12)+1
	bYear = 2018 - (bMonth>curMonth?age+1:age) #actually inaccurate...
	bDay = (rand(UInt8)%((bMonth==1 || bMonth==3 || bMonth==5 || bMonth==7 || bMonth==8 || 
							 bMonth==10 || bMonth==12) ? 31 : ((bMonth==4 || bMonth==6 || bMonth==9 || bMonth==11) ? 30 : 
							 ((((bYear%100!=0) && (bYear%400==0)) && (bYear%4==0)) ? 29 : 28) )))+1
	return (age, (string(bYear)*"-"*(bMonth<10?"0":"")*string(bMonth)*"-"*(bDay<10?"0":"")*string(bDay)))
end

#Makes up a person by returning the gender, names, body, race and ethnicity, and age.
function human_generator()
	gender = rand(UInt8)%2 #randint 0 or 1?
	return(gender, fname_generator(gender), lname_generator(), body_generator(gender), 
		  ((rand(UInt8)%6)+1), ((rand(UInt8)%2)+1), age_generator(6))
end

#Makes up a phone number
function phone_generator()
	number=""
	while length(number)!=10
		number = (rand(Int8)<0?"401":(rand(Int8)<0?"508":"617"))*
					string((rand(UInt8)%9)+1)*string(rand(UInt8)%10)*string(rand(UInt8)%10)*
					string((rand(UInt8)%9)+1)*string(rand(UInt8)%10)*string(rand(UInt8)%10)*string(rand(UInt8)%10)
	end
	return number
end

#Makes up an address based on a chosen state.
function address_generator()
	address = string((rand(UInt8)%1000)+1)*" "
	if rand(Int8) < 0
		#RI
		#make up street num and name, grab any ol' city, and the state name, then make a zip
		address*= (rand(Int8)<0?streets[1][(rand(UInt8)%length(streets[1]))+1]:(rand(Int8)<0 ? rhodeIslandCities[1][(rand(UInt8)%length(rhodeIslandCities[1]))+1] : lastNamePool[(rand(UInt8)%length(lastNamePool))+1] ))*" "*streets[2][(rand(UInt8)%length(streets[2]))+1]*" "*rhodeIslandCities[1][(rand(UInt8)%length(rhodeIslandCities[1]))+1]*" "*rhodeIslandCities[2]*" "*"028"
	else
		#MA
		address*= (rand(Int8)<0?streets[1][(rand(UInt8)%length(streets[1]))+1]:(rand(Int8)<0 ? massCities[1][(rand(UInt8)%length(massCities[1]))+1] : lastNamePool[(rand(UInt8)%length(lastNamePool))+1] ))*" "*streets[2][(rand(UInt8)%length(streets[2]))+1]*" "*massCities[1][(rand(UInt8)%length(massCities[1]))+1]*" "*massCities[2]*" "*(rand(Int8)<0?"02":"01")*string(rand(UInt8)%3)
	end
	address*= string(rand(UInt8)%10)*string(rand(UInt8)%10)
	return address
end

#Makes up a username
function uname_generator(fname, lname, dob)
	uname = (rand(Int8)<0 ? fname : fname[1])*(rand(Int8)<0 ? "_" : "")*lname*(rand(Int8)<0 ? (rand(Int8)<0 ? dob : string((rand(UInt8)%1000)+1)) : "")
	return uname
end

#Makes up an email address.
function email_generator(uname)
	return uname*"@"*emailProviders[rand(UInt8)%length(emailProviders)+1]
end

#Makes up a ssn
function ssn_generator()
	return string(rand(UInt8)%10)*string(rand(UInt8)%10)*string(rand(UInt8)%10)*"-"*
		   string(rand(UInt8)%10)*string(rand(UInt8)%10)*"-"*
		   string(rand(UInt8)%10)*string(rand(UInt8)%10)*string(rand(UInt8)%10)*string(rand(UInt8)%10)
end

###TODO: Medical data gens, personal data ie banking, social? find flags in REDCap and set them randomly, test for failures


#Makes a record for REDCap DB
function record_generator(config::Config, id; mode::String="demography")
	if mode=="demography"
		#Return a basic demography form
		(gender, fname, lname, (weight, height), race, ethnicity, (age, dob)) = human_generator()
		bmi = div(weight, ((height/100)^2))
		(telephone, address, email) = (phone_generator(), address_generator(), email_generator(uname_generator(fname, lname, dob[3:4])))
		return Dict("record_id" => string(id),
				"sex" => string(gender),
				"age" => string(age),
				"dob" => dob,
				"first_name" => fname,
				"last_name" => lname,
				"height" => 80,
				"weight" => 80,
				"bmi" => string(bmi),
				"telephone" => telephone,
				"ethnicity" => string(ethnicity),
				"race" => string(race),
				"address" => address,
				"email" => email,
				"comments" => "Randomly Generated - Demographics")

	elseif mode=="socialdata"
		#Return a basic demography form
		(gender, fname, lname, (weight, height), race, ethnicity, (age, dob)) = human_generator()
		uname = uname_generator(fname, lname, dob[3:4])
		(telephone, address, email) = (phone_generator(), address_generator(), email_generator(uname))
		ssn = ssn_generator()
		return Dict("record_id" => id,
					"first_name" => fname,
					"last_name" => lname,
					"telephone" => telephone,
					"address" => address,
					"email" => email,
					"ssn" => ssn,
					"username"=> uname,
					"comments" => "Randomly Generated - Mailing Data")

	elseif mode=="other"



	elseif mode=="garbage"


	else

	end
	


	#= -ex record:
	[
		{"record_id":GenerateNextRecordID(),
		 "sex":"1", #decide 50/50 on gender- choose names and height/weight based on gender
		 "age":"39", #random integer above 0 and below 112
		 "address":"123 Fake St. Providence RI 02895", #random integer 1-999, random word/name, random st/ave/rd, random city in RI, random zip 028XX
		 "height":"172.96", #randomly chosen based on m/f average +/- random deviation
		 "dob":"1978-07-08", #get todays date, subtract #years from that, +/- 6 months worth
		 "bmi":"26.7", #calc using height/weight
		 "comments":"",
		 "email":"JohnSmith78@gmail.com", #fname+lname+(optional)birth year+@(randomly chosen from gmail, yahoo, etc.)
		 "first_name":"John", #randomly assigned based on gender from pool of gender names (with slight chance of not)
		 "demographics_complete":"2",
		 "telephone":"(401) 888-9956", #(401)-XXX-XXXX (randomly assigned)
		 "weight":"80", #randomly chosen from average +/- random dev
		 "last_name":"Smith", #randomly chosen from list of last names
		 "ethnicity":"2", #chosen randomly, decides race
		 "race":"4"} #also chosen randomly with ethnicity - find out exactly what numbers mean
	]
	=#

	#= -produced record:
		{"sex":"1",
		"age":"16",
		"address":"114 Coventry Rd. Smithfield RI 02887",
		"height":"164.7",
		"dob":"2001-11-26",
		"record_id":"x",
		"bmi":"34.0",
		"comments":"Randomly Generated",
		"email":"CoryPark70@aol.com",
		"first_name":"Cory",
		"telephone":"(401) 585-4437",
		"weight":"94.8",
		"ethnicity":"4",
		"last_name":"Park",
		"race":"1"}
	=#

	#Dict{String, String}()

end