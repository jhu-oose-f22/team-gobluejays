<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

<img width="388" alt="image" src="https://user-images.githubusercontent.com/77982805/194137270-7f759a30-1295-419f-8fd3-94db9ac750c5.png">

* website: https://gobluejays.netlify.app

There're numerous web and mobile applications supporting students' life in JHU, yet functions of every application are too discrete so that students have to switch among various applications, which is inconvenient. For daily communication, course information, and academic resources, students would use a variety of apps at the same time, including Slack, Teams, Piazza, and SIS. Not to mention applications for school life like TransLoc, Hop-Rec, etc.

Moreover, it also paves a new way to improve upon the flaws in the existing applications used by JHU students, which are stated below:

Current JHU calendar application, Smesterly, does not have a mobile version, and details of courses, like where to submit assignments and when to take a midterm-exam, could not be added and showed in calendars.
CampusGrpup is the only application where students can obtain information about campus events. However, it has a poor UI design and only allows students to view and register activities. Students won't be notified or even recommended if they don't voluntarily go to the page and check the activity list.



### Built With

This section should list any major frameworks/libraries used to bootstrap your project. Leave any add-ons/plugins for the acknowledgements section. Here are a few examples.

* Swift
* Cocoapods
* Xcode
* MongoDB / SQLite

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- GETTING STARTED -->
## Getting Started
* Download Xcode in app store
* Download cocoapods following https://www.bilibili.com/video/BV12F4113794?p=113&vd_source=dcfa70e0de27daf616f415670fe6e116
* Git clone in Xcode using HTTPS code from our github repo
* Click the triangle on top left to get started!

### Prerequisites
Navigate to local repo in terminal
* cocoapods
  ```sh
  pods install
  ```

### Installation

1. Clone the repo in Xcode
   ```sh
   git clone https://github.com/jhu-oose-f22/team-gobluejays.git
   ```
2. Install cocoapods packages
   ```sh
   pods install
   ```

* If you are facing the error “Framework Not Found”, follow https://developer.apple.com/forums/thread/660864 for instruction. Remove arm64 from the setting, run the app, add arm64 back, and run it again. The problem should be fixed.


<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [x] Add to Schedule
    - [x] implement frontend of the weekly calendar
    - [x] add custom event to schedule
    - [x] implement the backend for user events and activity
    - [ ] connect the backend to current codebase
- [x] View campus events
    - [x] implement frontend of the campus event tab
    - [x] design UI interface of the event page on Figma#11
- [ ] Access school apps and websites
    - [x] Add more Apps and Websites to Apps/Websites Sections (Find icons online)
    - [x] Create Apps and Websites Section on Home Page
    - [ ] Link About sections to appropriate websites, imitate UI from Academics for Athletics, Housing, Social Media sections
- [ ] Setting page
    - [x] set up team website
    - [ ] design user profile interface
    - [ ] design user profile

See the [open issues](https://github.com/jhu-oose-f22/team-gobluejays/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- CONTACT -->
## Contact

Jessie Luo - jluo30@jhu.edu

Project Link: [https://github.com/jhu-oose-f22/team-gobluejays](https://github.com/jhu-oose-f22/team-gobluejays)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments
* [Stakeoverflow](https://stackoverflow.com)
* [Protocol Delegate in Swift](https://www.youtube.com/watch?v=Z9eSUE-lzig&t=757s)
* [Figma](https://www.figma.com)
* [GitHub Pages](https://pages.github.com)
* [Xcode documents](https://developer.apple.com/xcode/resources/)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/othneildrew/Best-README-Template.svg?style=for-the-badge
[contributors-url]: https://github.com/othneildrew/Best-README-Template/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/othneildrew/Best-README-Template.svg?style=for-the-badge
[forks-url]: https://github.com/othneildrew/Best-README-Template/network/members
[stars-shield]: https://img.shields.io/github/stars/othneildrew/Best-README-Template.svg?style=for-the-badge
[stars-url]: https://github.com/othneildrew/Best-README-Template/stargazers
[issues-shield]: https://img.shields.io/github/issues/othneildrew/Best-README-Template.svg?style=for-the-badge
[issues-url]: https://github.com/othneildrew/Best-README-Template/issues
[license-shield]: https://img.shields.io/github/license/othneildrew/Best-README-Template.svg?style=for-the-badge
[license-url]: https://github.com/othneildrew/Best-README-Template/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/othneildrew
[product-screenshot]: images/screenshot.png
[Next.js]: https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white
[Next-url]: https://nextjs.org/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://reactjs.org/
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/
[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[Svelte-url]: https://svelte.dev/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com 
