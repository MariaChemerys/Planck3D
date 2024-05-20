<h1 align="center">Planck 3D</h1>
<p align="center">
<img src="https://github.com/MariaChemerys/Planck3D/blob/main/Planck3D%20GIF.gif?raw=true" width="200" height="450"/>
</p>
<h2>What is Planck3D?</h2>
<b>Planck3D</b> is an iOS app that provides the 3D representation of the Planck's Law, a fundamental equation in Physics.<br>
<b>Planck's Law</b> relates the spectral radiance of a black body (an idealized object that absorbs all incoming electromagnetic radiation) to its temperature and wavelength:
<p align="center">
<img src="https://github.com/MariaChemerys/Planck3D/blob/main/Planck's%20Law.png?raw=true" width="320"/>
</p>
Where:<br>
• B is the spectral radiance in watts per square meter per steradian per meter (W⁻²sr⁻¹m⁻¹)<br>
• λ is the wavelength in metres (m)<br>
• T is the temperature in kelvins (K)<br>
• h is Planck's constant in joule-seconds (6.626 ⋅ 10⁻³⁴ Js)<br>
• c is the speed of light in a vacuum in metres per second (3.0 ⋅ 10⁸ ms⁻¹)<br>
• k is the Boltzmann constant in joules per kelvin (1.381 ⋅ 10⁻²³ JK⁻¹)<br>
<h2>Why is Planck3D Useful?</h2>
Planck3D can provide many educational benefits:<br>
• It allows users to experiment with a Planck's Law 3D model by <strong><em>changing the maximum temperature, wavelength and spectral radiance</em></strong> visible on the plot. Getting an immediate visual feedback reinforces the understanding of the relationship between these quantities.<br>
• Planck's law involves advanced concepts such as <strong><em>quantum mechanics and blackbody radiation</em></strong>. A 3D representation makes it easier to witness how these concepts interrelate.<br>
• In the app, it is possible to <strong><em>zoom in on specific regions</em></strong> of the plot and <strong><em>rotate it</em></strong> to examine finer details, patterns and trends that may not be apparent in a static plot. This may lead to a deeper comprehension of the underlying physics.
<h2>Why is Planck3D Technically Efficient and Elegant?</h2>
In order to build Planck3D, the following advanced frameworks were used:<br>
• <b>Plot3D</b> and <b>SceneKit</b> were implemented to create the 3D plot representation of the Planck's Law and efficiently manage its geometry, transformations, lighting, and rendering.<br>
• <b>SwiftNumerics</b> and <b>SwiftMath</b> were employed to perform the sophisticated mathematical computations required for data visualisation.<br>
• <b>Combine</b> framework assisted in transferring data between <b>SwiftUI</b> and <b>UIKit</b> by handling asynchronous data streams. In Planck3D, SwiftUI views receive data from the user, such as the the maximum temperature, wavelength and spectral radiance visible on the plot. The Combine framework helps to transfer them into the UIKit view controller, which updates the 3D plot according to the user's preferences.<br>
• <b>CoreHaptics</b> was used to enhance the user experience by providing haptic feedback.
<h2>Installation Instructions</h2>
1. Open Xcode<br>
2. Click on "Clone Git Repository"<br>
3. Paste the following URL: https://github.com/MariaChemerys/Planck3D.git <br>
4. Click "Clone"<br>
5. Build and run the project in Xcode<br>
<h2>Technologies Used</h2>
<p align="left">
  <img src="https://img.shields.io/badge/XCode-blue?style=for-the-badge&logo=#5B4638" alt="XCode" />
  <img src="https://img.shields.io/badge/Cocoapods-red?style=for-the-badge&logo=#5B4638" alt="Cocoapods" />
  <img src="https://img.shields.io/badge/SwiftUI-fffb0a?style=for-the-badge&logo=#5B4638" alt="SwiftUI" />
  <img src="https://img.shields.io/badge/UIKit-4bff0a?style=for-the-badge&logo=#5B4638" alt="UIKit" />
  <img src="https://img.shields.io/badge/Combine-ef13f2?style=for-the-badge" alt="Combine" />
  <img src="https://img.shields.io/badge/Plot3D-ba91ff?style=for-the-badge" alt="Plot3D" />
  <img src="https://img.shields.io/badge/SceneKit-f74fa3?style=for-the-badge" alt="SceneKit" />
  <img src="https://img.shields.io/badge/SwiftNumerics-6b4ff7?style=for-the-badge" alt="SwiftNumerics" />
  <img src="https://img.shields.io/badge/SwiftMath-4ff7b4?style=for-the-badge" alt="SwiftMath" />
  <img src="https://img.shields.io/badge/CoreHaptics-fabc1e?style=for-the-badge" alt="CoreHaptics" />
</p>

