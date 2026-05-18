# Start G-Code Options

This folder contains options for the Start G-Code section of your slicer.



These are based on the Prusa default start G-Code but with a few options:



* **Tweaked NoPreheat** - This is likely the standard for most folks. 

  It *DOES NOT* do a preheating of the bed, but *DOES* include the "Absorbing Heat" pause (`G29 G`) before printing starts, to allow for expansion of the printbed and related areas.
  
* **Tweaked PreHeat** - This version adds an extended full-bed preheat to allow for everything to expand and come up to temperature. It sets the bed to 100C for 5 minutes, then continues with the printing process. **I have found this to be very useful for printers sitting in a relatively cold room like a basement or garage.**

  It also *DOES* a hardcoded 30 second pause in place of the Absorbing Heat phase (`G29 G`) before printing starts, to allow for a little cooling time from the preheat temperature down to the desired printbed set value. Note that the extended preheat first warms the entire bed before then doing the absorbing heat on the printed area only.
  
* **Tweaked OctoPrint** - This is a highly specialized file for those managing their printer via OctoPrint or another tool like PrusaConnect. This is used for a case where you have manually pre-heated the bed and possibly the tool hot-end and want the absolute fastest print time with no pre-print pauses. 

  It *DOES NOT* do a preheating of the bed, and *DOES NOT* include the "Absorbing Heat" pause (`G29 G`) before printing starts.

  **WARNING: Using this without a pre-warmed bed may lead to bad bed probing results as it does not allow any time for the heat to soak into the bed and frame.**
