
Here are some guidlines.

As pointed out by Charlie: 
Any multithreading in c inside kdb+ requires kdb+ to be in a multithreaded mode itself, either negative port mode or with slave threads; otherwise ref counts can go wrong.
The golden rules are that k objects cannot be shared between threads, and k objects must be freed from the threads in which they were allocated.

I normally constraint myself to doing things that don't cause any side effect in my child thread. -- pure lamda or reading is fine... if you have to update, I believe you can only update atom without causing issues.

The common practise is to separate the logic out to a separate q process... 
