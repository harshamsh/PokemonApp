#Our application consists of several Haskell files such as 
#• Main.hs
#• Fetch.hs
#• Types.hs
#• Database.hs
#• Paarse.hs
#The way our application runs is our main.hs provides a terminal to the user where the 
user can choose what to do with the application and the application.vairous hs files are 
been imported to main for this purpose,for example if a user decides to downlaod the 
data from the internet applciation will be usign fetch.hs to downlaod the data and then 
our parse.hs parses the JSON type data we have downloaded to the requierd type data 
which has been defiend in type.hs finally we use databse.hs to store the values in 
proper fields in the so called tables with respective column structure defined.The 
secondary fucntion of database.hs is to do the queries asked by the user in the main 
terminal if the user decides to do the query rather than download the data.
