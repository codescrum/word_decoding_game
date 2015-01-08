#String Encoder Game Server (by Codescrum)

This is simple game for learning ruby!
This is the server part of a game that consists of decoding words.

##How is the game?

1. There is a server (this one)
2. You ask the server for a word
3. The server responds with a word, but it is encoded
4. You decode the encoded word and submit it to the server, to check if it is correct
5. The server tells you if the decoded word is correct

   - If the response is correct, it responds with an OK message and it also
     tells you the next url you have to go to, to continue with the next challenge.

  - If the response is not correct, then, you have to try again

Please note:

1. All words are in lowercase, no numbers, and are common words, all words have more than 4 letters, and they are intuitively easy to reverse-engineer, the important thing is that you use ruby to construct the decoder in each challenge.

2. Each time you ask for a word, it could be a different one!. The idea of the game is that you have to reverse-engineer the algorithm that generates the words.

3. Sometimes the encoded word may leave you in a position where you have multiple 'candidates' for the decoded word. You can try sending multiple words to the server, you have multiple attempts to guess the correct word.

4. Do not try to cheat the system by hand, the server only waits 2 seconds for you to guess the correct word each time :P. After the time has elapsed, you will have to request a new word.


##Technical Gameplay

1. Asking the server for a word

   In order to ask the server to give you a word you must submit a GET request to the following endpoint:

       GET /word

2. To submit a decoded word response to the server

   In order to check your decoded word you must submit a GET request with your answer to

       GET /answer/?answer=<your-decoded-word>

   Where the :word part in the url is the original (encoded) word sent to you and <your-decoded-word> is...well, your answer/guess.

4. Always print the answer from the server so you know if you have succeeded or not.

3. If you run out of time (the 2 second rule) you will see the following message come back to you:

        TIMEOUT! - You have run out of time, please ask for a new word!

4. When you guess the word correctly, this will tell you what the next challenge url is. When you have submited a correct answer, the server will respond like this:

        OK! - You have succesfully completed this challenge, please ask for another word to see the next challenge

   When you complete a challenge you may ask for the next word by issuing a GET /word request

       GET /word

   And again, try to decipher and reverse-engineer the algorithm.

##Getting Started

To run the server, just do

    bundle install
    ruby server.rb

Then, go to the client application and begin working out the codes!
If you are running this server locally (at localhost) you will find the server at:

        localhost:4567/word
