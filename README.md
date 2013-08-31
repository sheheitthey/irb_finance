irb_finance
===========

A personal finance toolkit for use in irb (interactive Ruby).

I originally started this with my brother, to simultaneously teach him about
personal finance, the exponential function, and coding. Later I ended up
enhancing it a bit and using it myself for predicting my taxes and choosing a
mortgage. It was helpful compared to other desktop software, online tools, and
(of course) manual notes because I could very quickly make personal tweaks and
redo the computations.

The annuities module matches what online calculators output, down to the cent.
The tax module was mostly accurate at the time, but tax rules and threshold
values have changed since then. The income module just works out high level
income and savings projections for an individual, and when combined with the
(quickly hacked up) plot module was helpful for visualizing how the values
grow in the long term.
