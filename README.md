
# PS1 Software Development

## Food Hut
#### Food Hut is a fully fledged food ordering appliction where you can directly choose fooditems, checkout your order and recieve it through a qr scan by shop owner.

## Demo
#### The Video Demo [See from here](https://youtu.be/SYwHqYY_35s).
#### The build version of application can be [downloaded from here](https://drive.google.com/file/d/1GuIB_97dN8bCFZmVZGzEqEgVgtsgpSBt/view?usp=sharing).

## 🧩 Main Features
- Separate admin, user views in one app
- Multiple features like QR scanning, add/update items etc provided to admin for shop managment.
- User side provided with interactive UI with different screens like cart page, current orders, orders history etc.

## 📖 Pages
#### <ul>
- Welcome Screen
- Login & Signup Screens
- admin side
  - Home page
  - Add item page
  - Scan QR page
  - Update Item details page
  - Orders Queue page
- user side
  - Home page
  - Cart page
  - Current Orders page
  - Last Orders page
</ul>

## 💻 TechStack Used
#### <ul><li>Flutter (for application/frontend)</li><li>Firebase (for backend services)</li></ul>

## Setting up project on your machine ⚙️
- [Follow this guide](https://swciitg.notion.site/Day-1-f6ea19b1d7ff410e8ec03683772f4cd0) to setup Android Studio & Flutter SDK on your machine

## 🎪 Running application
```
- Run "dart pub get" command to download all the dependencies used in this project.

- To run the application on a Physical device/Virtual Emulator use command "flutter run" at the root of this project's directory.

- Use "kunalpal215@gmail.com as email and Kriti@2023 to login as admin"

```

# Why built an app, chose flutter 🤔?
- Looking at the feasiblity of the problem statement and research done by team, we found to implement an app based solution better compared to some website.
- Flutter is a cross-platform app framework where the developers are expected to write the code for the apps in Dart, Flutter is the framework…Dart is the language.
- With flutter, the same codebase can be used for ios, android app release.

# 🎨 Design

- We chose firebase as service provider and made use of Firebase Auth, Cloud Firestore, Firebase Storage in our app.
- Firebase Auth provides backend services, easy-to-use SDKs, and ready-made UI libraries to authenticate users in app.
- Cloud Firestore is a NoSQL document database that lets anyone easily store, sync, and query data for your mobile and web apps - at global scale.
- Cloud Storage for Firebase is built for app developers who need to store and serve user-generated content, such as photos or videos.
- We tried to implement following flutter coding best practices in the project as much as possible.
- For QR Generation of any order, we used a string formed by concatenation of useremail, his order's unique id.
- Cloud Firestore collections structure: 
  - admin // collection
    - auth emails // document
      - emails (list of admin emails string for food shop) // document field
    - currentOrder //document
      - orderNumber (order number of ready order) //document field
    - lastOrder //document
      - orderNumber (order number of ready order) // document field
      - email (useremail) // document field
  - user // collection
    - user and order details // document
      - cart (array of map) // document field
        - {foodname: String, quantity: 2} // map fields
      - hasOrder (bool) // document field
      - orderNumber (smallest order number) // document field
      - currentOrder // collection
        - orderdetails // document
          - orderInfo (array of map) // document field
            - {foodname: String, quantity: 2, price: number} // map fields
        - orderFulfilled (bool) // document field
        - orderNumber (number) // document field
        - timestamp (number) // document field
        - totalBill (number) // document field
      - lastOrder // collection
        - orderdetails // document
          - orderInfo (array of map) // document field
            - {foodname: String, quantity: 2, price: number} // map fields
        - orderFulfilled (bool) // document field
        - orderNumber (number) // document field
        - timestamp (number) // document field
        - totalBill (number) // document field
  - fooditems // collection
    - item details // document
     - imageURL (string) // document field
     - itemname (string) // document field
     - outOfStock (bool) // document field
     - price (number) // document field

# 🧛 Regrets
- We could have created a separate backend for our app and integrate app components with the apis and that would have been a game changer. how would it overcome current challenges ?
    - Integrating Firebase SDK in Flutter causes the app to perform slow compared to directly making API requests to your server.
    - Also, now application & backend's code remain separated and development can be done easily, scaling application & backend side.
    - Most modern applications follow same practice of separating their different services.
- We started this project by generalising that through some super admin panel, we will be able to create different kind of shops for listing on the app. but, this got droppped as team found it pretty difficult to implement under the duration provided and eventually wasted our much time.
- We focused to create this app keeping perspective that only a single shop is there, but we could have created an extra shop for stationary if proper time managment would have been there.

# 🐛 Bug Reporting
#### Feel free to [open an issue](https://github.com/Kunalpal215/helpzz/issues) on GitHub if you find any bug.

<br />

# ⭐ General Details
#### Feel free to [open an issue](https://github.com/Kunalpal215/helpzz/issues) on GitHub if you have feature idea to be added 🙌.

```
Submitted by:
Hostel: Brahmaputra
Team distribution: two 3rd year, 3 second year, 1 first year

Thanks for visiting our repository 😊!! Please give a star ⭐ if you liked our submisstion. We are open to suggesstions so, please share them by creating an issue.
```