# transformers
Tech Test from a local Company

## UPDATE Oct 2019:

1. I was happy with the code I'd created in the time given. The Battle logic and 100% tests  are where functional programming has taken me. All other views classes are also able to be 100% tested  - given time to write tests.

2. I didn't get an interview but I learnt a lot about myself and avoiding this kind of test process in the future - this could be gleaned in a 1/2 hour discussion! This really got me contemplating the best use of my engineering skills.

--------------------------------

This test took me approx 18 hours to complete over a week+

It was more time than I was planning...

I creating a well crafted app, rather than any visual components which is not my forte. However, I am used to, and experienced in implementing pixel perfect designs from sketch, PS or similar and working closely with grapic designers to implement areas that also required specific animations sometimes driven by certain user actions/inputs.

They also asked for some explanation of classes written:

Environment - Current global structure of needed properties.
User - Current User / auth token

Transformer - Model data
Transformers - Current & resident DB of [ID:Transformer]
BattleLogic - Game to run the battle of each ranked team member

FakeSplash / FakeCover - Provided for initial routing and flow
Note: All ViewControllers below have ViewController/Interactor/Presenter classes for testing
LoginVC - Get the Allspark token!   (Testing example showing in LoginTests)
ShowTransformers - List of current Transformers
CreateTransformer - Create or Edit Transformers
BattleTransoformers - Did not have time to present any of the battle screen...but code is tested.
ViewUtils - Just some extensions

FireBase - Transformers API
API Service
Utils - Handy stuff

With a certain amount of dependency injection and utiliizing the latest snapshot testing tools, it's possible to have a very well tested app, including visual layouts, without having to rely on slower UITesting, which can often be distracting from the real issues.

I do hope there is enough code in place to get a feel for my coding style and approach.
