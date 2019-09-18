# transformers
Tech Test from a local Company

This test took me approx 14 hours to complete over about a week+.

It was more time than I was planning, but there was three big ask. API, App and Logic.

Although the brief seemed to look for a creative 'design' element I hope that would also include creating a well crafted app, rather than implementing/creating some visual components which is not my forte. Howvere, I am used to and experienced in implementing pixel perfect designs from sketch, PS or similar and working closely with grapic designers to implement areas that also required specific animations sometimes driven by certain user actions/inputs.

I wrote the app from scratch, usually I would've pushed up to iTunes and delivered a working app but had to call it based on the time/effort I'd put in.

I really wanted to demonstrate my ability to create a highly minatainable, testable code base that has clean arcitechture principles, yet built in a simple digestable manner.

Class Docs:
Environment - Current global structure of needed properties.
User - Current User / auth token
Transformer - Model data
BattleLogic - Game to run the battle
FakeSplash / FakeCover - Provided for initial routing and flow
Note: All ViewControllers below have ViewController/Interactor/Presenter classes for testing
LoginVC - Get the Allspark token!   (Testing example showing in LoginTests)
ShowTransformers - List of current Transformers
CreateTransformer - Create or Edit Transformers


With a certain amount of dependency injection and utiliizing the latest snapshot testing tools, it's possible to have a very well tested app, including visual layouts, without having to rely on slower UITesting, which can often be distracting from the real issues.

Thx and I look forward to hearing any feedback you have from my efforts...

Jules.
