# Windows Setup

1. Open Run (`Win+R`) and enter:

   `ms-settings:mousetouchpad`

   - Enhance Pointer Precision: **Disable**
   - Mouse Pointer Speed: **5**

2. Open Run (`Win+R`) and enter:

   `ms-settings:taskbar`

   - Taskbar Behaviors → Automatically Hide Taskbar: **Enable**

3. Open Run (`Win+R`) and enter:

   `ms-settings:multitasking`

   - Snap Windows → When I snap a window, suggest what I can snap next to it: **Disable**

4. Open Run (`Win+R`) and enter:

   `powercfg.cpl`

   - Set **High Performance Profile**

5. Run:

   `winget configure packages.dsc.yaml`

6. Install the drivers listed in: `drivers.txt`

7. Import the PowerToys settings file: `.ptb`