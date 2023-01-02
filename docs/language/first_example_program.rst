First Example Program
######################

.. code-block:: wyrm
  :linenos:

  UGen {
    // Instance variables are private by default but the compiler can write
    // accessor and setter methods, or they can be provided using the same
    // syntax as sclang.

    int < samplesPerSecond; // default for integers is 0.

    // Wyrm will write a constructor for you that takes default arguments
    // based on the order of definition of the member variables. There are
    // no class methods. After setting the provided or default values in the
    // constructor Wyrm can call an _init function, if one is defined. For
    // inherited classes it will call _init in order for each type in
    // base-to-derived order.
    nil _init {}

    // There's also a _shutDown method which wyrm will call before reclaiming
    // the memory when garbage collecting. There's no deterministic certainty
    // around when _shutDown will be called, if ever. For inherited classes
    // it will call _shutDown for each type in derived-to-base order.
    nil _shutDown {}

    // Base render implementation fills the supplied buffer with zeroes.
    int render { |FloatArray buffer|
      buffer.fill(0.0);
      ^buffer.size();
    }

    // Note the unused keyword here to prevent an error.
    nil skipAhead{ |unused long samplesToSkip| }
  }

  SinOsc : UGen {
    float < freq = 440.0, phase = 0.0, mul = 1.0, add = 0.0;
    long nextSampleNumber = 0;

    float samplePeriod; // default for floats is 0.0.

    nil _init {}

    int render { |FloatArray buffer|
      float samplePeriod = 1.0 / samplesPerSecond.asFloat();
      float t = nextSampleNumber.asFloat() * samplePeriod;
      buffer.do({ |unused float x, int i|
        buffer[i] = add + (mul * sin((t * freq * 2.0 * Float.pi()) + phase));
        t += samplePeriod;
      });

      ^buffer.size();
    }

    nil skipAhead(long samplesToSkip) {
      nextSampleNumber += samplesToSkip;
    }
  }

  // I don't think we need the AbstractFunction framework. SynthDefs provide
  // a function consisting of a mix of regular code and re-usable UGen-style
  // objects. The function can be called periodically to render to a buffer
  // of audio. This function-like object should have the same API as an
  // individual UGen. Wyrm should compile this object and optimize it audio
  // rendering, so that when it is triggered it can render frames. But UGens
  // can have a wide variety of requirements. They may need setup code, have
  // asynchronous or non-real time tasks (like loading a file), etc.

  // UGens can also support variation of some parameters on a per-sample or
  // per-frame basis.

  // Operator overloading?

  (
    SynthDef.new(\a, { Out.ar(0, SinOsc.ar()) });

    // automatic type deduction using `var`
    var a = Synth.new(\a);
  )


