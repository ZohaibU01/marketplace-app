import 'package:flutter/material.dart';
import 'package:toysell_app/MVC/model/productModel.dart';
import 'package:toysell_app/MVC/model/categoryModel.dart';
import 'package:toysell_app/MVC/model/messageModel.dart';

import '../MVC/view/Profile/follower_following_screen.dart';

class MockData {
  static List<MessageModel> dummyMassages = [
    MessageModel(
      id: 1,
      messageType: MessageType.text,
      content: "Hello, how are you?",
      userId: 1,
      Sendertype: 'sender',
      date: DateTime.now(),
    ),
    MessageModel(
      id: 2,
      messageType: MessageType.text,
      content: "I'm doing great! How about you?",
      userId: 2,
      Sendertype: 'reciver',
      date: DateTime.now().add(const Duration(minutes: 5)),
    ),
    MessageModel(
      id: 3,
      messageType: MessageType.image,
      content: "Check out this image!",
      media: "https://example.com/image.jpg",
      userId: 1,
      Sendertype: 'sender',
      date: DateTime.now().add(const Duration(minutes: 10)),
    ),
    MessageModel(
      id: 4,
      messageType: MessageType.video,
      content: "Watch this video!",
      media: "https://example.com/video.mp4",
      Sendertype: 'reciver',
      userId: 2,
      date: DateTime.now().add(const Duration(minutes: 15)),
    ),
    MessageModel(
      id: 1,
      messageType: MessageType.text,
      content: "Hello, how are you?",
      userId: 1,
      Sendertype: 'sender',
      date: DateTime.now(),
    ),
    MessageModel(
      id: 2,
      messageType: MessageType.text,
      content: "I'm doing great! How about you?",
      userId: 2,
      Sendertype: 'reciver',
      date: DateTime.now().add(const Duration(minutes: 5)),
    ),
    MessageModel(
      id: 3,
      messageType: MessageType.image,
      content: "Check out this image!",
      media: "https://example.com/image.jpg",
      userId: 1,
      Sendertype: 'sender',
      date: DateTime.now().add(const Duration(minutes: 10)),
    ),
    MessageModel(
      id: 4,
      messageType: MessageType.video,
      content: "Watch this video!",
      media: "https://example.com/video.mp4",
      Sendertype: 'reciver',
      userId: 2,
      date: DateTime.now().add(const Duration(minutes: 15)),
    ),
    MessageModel(
      id: 1,
      messageType: MessageType.text,
      content: "Hello, how are you?",
      userId: 1,
      Sendertype: 'sender',
      date: DateTime.now(),
    ),
    MessageModel(
      id: 2,
      messageType: MessageType.text,
      content: "I'm doing great! How about you?",
      userId: 2,
      Sendertype: 'reciver',
      date: DateTime.now().add(const Duration(minutes: 5)),
    ),
    MessageModel(
      id: 3,
      messageType: MessageType.image,
      content: "Check out this image!",
      media: "https://example.com/image.jpg",
      userId: 1,
      Sendertype: 'sender',
      date: DateTime.now().add(const Duration(minutes: 10)),
    ),
    MessageModel(
      id: 4,
      messageType: MessageType.video,
      content: "Watch this video!",
      media: "https://example.com/video.mp4",
      Sendertype: 'reciver',
      userId: 2,
      date: DateTime.now().add(const Duration(minutes: 15)),
    ),
    // Add more dummy messages as needed
  ];

  static List<Map<String, dynamic>> onSliderData = [
    {
      'index': 0,
      'image': "p1.png",
      'heading': "Let’s Get Started",
      "content":
          "\"Start your journey today by discovering a world of preloved toys for your little one. Whether you’re looking to buy or sell, we make it easy to find quality kids products and enjoy fast delivery!\""
    },
    {
      'index': 1,
      'image': "p2.png",
      'heading': "Your Onboarding Journey Begins!",
      "content":
          "\"Capturing and sharing your child’s gently used toys has never been simpler! Snap a picture, list your item, and connect with other families who are excited to buy and sell the best kids' products.\""
    },
    {
      'index': 2,
      'image': "p3.png",
      'heading': "Your First Steps To Success",
      "content":
          "\"Ready to ship your preloved toys to happy homes? With our easy process and fast delivery, you’re not just selling – you’re making another family’s day while decluttering with ease!\""
    },
  ];

  static List<ProductModel> products = [
    // ProductModel(
    //   id: 1,
    //   name: 'Product name',
    //   description:
    //       'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since.',
    //   price: 89.99,
    //   imageUrl:
    //       'https://i.etsystatic.com/23883117/r/il/130519/2846519551/il_570xN.2846519551_ck9y.jpg',
    //   // Using the first image as the main image
    //   images: [
    //     'https://i.etsystatic.com/23883117/r/il/130519/2846519551/il_570xN.2846519551_ck9y.jpg',
    //     'https://i.etsystatic.com/24971278/r/il/ad3f68/3244436294/il_1080xN.3244436294_7jtm.jpg',
    //   ],
    //   category: 'Accessories',
    //   // Added a placeholder category
    //   subCategory: 'Bags',
    //   // Added a placeholder sub-category
    //   slug: 'product-name',
    //   // Added a slug
    //   videoLink: null,
    //   // Assuming no video link
    //   address: '123 Main Street, Anytown, USA',
    //   // Placeholder address
    //   latitude: 40.7128,
    //   // Placeholder latitude (New York City)
    //   longitude: -74.0060,
    //   // Placeholder longitude (New York City)
    //   isPremium: true,
    //   // Assuming the product is premium
    //   contact: '123-456-7890',
    //   // Placeholder contact
    //   country: 'USA',
    //   // Placeholder country
    //   state: 'New York',
    //   // Placeholder state
    //   city: 'New York City',
    //   // Placeholder city
    //   sellerName: 'Seller Name',
    //   sellerPicture:
    //       'https://plus.unsplash.com/premium_photo-1689977968861-9c91dbb16049?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8fDA%3D',
    //   rating: 10,
    // ),
    // ProductModel(
    //   id: 1,
    //   name: 'Product name',
    //   description:
    //       'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since.',
    //   price: 89.99,
    //   imageUrl:
    //       'https://i.etsystatic.com/23883117/r/il/130519/2846519551/il_570xN.2846519551_ck9y.jpg',
    //   // Using the first image as the main image
    //   images: [
    //     'https://i.etsystatic.com/23883117/r/il/130519/2846519551/il_570xN.2846519551_ck9y.jpg',
    //     'https://i.etsystatic.com/24971278/r/il/ad3f68/3244436294/il_1080xN.3244436294_7jtm.jpg',
    //   ],
    //   category: 'Accessories',
    //   // Added a placeholder category
    //   subCategory: 'Bags',
    //   // Added a placeholder sub-category
    //   slug: 'product-name',
    //   // Added a slug
    //   videoLink: null,
    //   // Assuming no video link
    //   address: '123 Main Street, Anytown, USA',
    //   // Placeholder address
    //   latitude: 40.7128,
    //   // Placeholder latitude (New York City)
    //   longitude: -74.0060,
    //   // Placeholder longitude (New York City)
    //   isPremium: true,
    //   // Assuming the product is premium
    //   contact: '123-456-7890',
    //   // Placeholder contact
    //   country: 'USA',
    //   // Placeholder country
    //   state: 'New York',
    //   // Placeholder state
    //   city: 'New York City',
    //   // Placeholder city
    //   sellerName: 'Seller Name',
    //   sellerPicture:
    //       'https://plus.unsplash.com/premium_photo-1689977968861-9c91dbb16049?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8fDA%3D',
    //   rating: 10,
    // ),
    // ProductModel(
    //   id: 1,
    //   name: 'Product name',
    //   description:
    //       'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since.',
    //   price: 89.99,
    //   imageUrl:
    //       'https://i.etsystatic.com/23883117/r/il/130519/2846519551/il_570xN.2846519551_ck9y.jpg',
    //   // Using the first image as the main image
    //   images: [
    //     'https://i.etsystatic.com/23883117/r/il/130519/2846519551/il_570xN.2846519551_ck9y.jpg',
    //     'https://i.etsystatic.com/24971278/r/il/ad3f68/3244436294/il_1080xN.3244436294_7jtm.jpg',
    //   ],
    //   category: 'Accessories',
    //   // Added a placeholder category
    //   subCategory: 'Bags',
    //   // Added a placeholder sub-category
    //   slug: 'product-name',
    //   // Added a slug
    //   videoLink: null,
    //   // Assuming no video link
    //   address: '123 Main Street, Anytown, USA',
    //   // Placeholder address
    //   latitude: 40.7128,
    //   // Placeholder latitude (New York City)
    //   longitude: -74.0060,
    //   // Placeholder longitude (New York City)
    //   isPremium: true,
    //   // Assuming the product is premium
    //   contact: '123-456-7890',
    //   // Placeholder contact
    //   country: 'USA',
    //   // Placeholder country
    //   state: 'New York',
    //   // Placeholder state
    //   city: 'New York City',
    //   // Placeholder city
    //   sellerName: 'Seller Name',
    //   sellerPicture:
    //       'https://plus.unsplash.com/premium_photo-1689977968861-9c91dbb16049?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8fDA%3D',
    //   rating: 10,
    // ),
    // ProductModel(
    //   id: 1,
    //   name: 'Product name',
    //   description:
    //       'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since.',
    //   price: 89.99,
    //   imageUrl:
    //       'https://i.etsystatic.com/23883117/r/il/130519/2846519551/il_570xN.2846519551_ck9y.jpg',
    //   // Using the first image as the main image
    //   images: [
    //     'https://i.etsystatic.com/23883117/r/il/130519/2846519551/il_570xN.2846519551_ck9y.jpg',
    //     'https://i.etsystatic.com/24971278/r/il/ad3f68/3244436294/il_1080xN.3244436294_7jtm.jpg',
    //   ],
    //   category: 'Accessories',
    //   // Added a placeholder category
    //   subCategory: 'Bags',
    //   // Added a placeholder sub-category
    //   slug: 'product-name',
    //   // Added a slug
    //   videoLink: null,
    //   // Assuming no video link
    //   address: '123 Main Street, Anytown, USA',
    //   // Placeholder address
    //   latitude: 40.7128,
    //   // Placeholder latitude (New York City)
    //   longitude: -74.0060,
    //   // Placeholder longitude (New York City)
    //   isPremium: true,
    //   // Assuming the product is premium
    //   contact: '123-456-7890',
    //   // Placeholder contact
    //   country: 'USA',
    //   // Placeholder country
    //   state: 'New York',
    //   // Placeholder state
    //   city: 'New York City',
    //   // Placeholder city
    //   sellerName: 'Seller Name',
    //   sellerPicture:
    //       'https://plus.unsplash.com/premium_photo-1689977968861-9c91dbb16049?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8fDA%3D',
    //   rating: 10,
    // ),
    // ProductModel(
    //   id: 1,
    //   name: 'Product name',
    //   description:
    //       'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since.',
    //   price: 89.99,
    //   imageUrl:
    //       'https://i.etsystatic.com/23883117/r/il/130519/2846519551/il_570xN.2846519551_ck9y.jpg',
    //   // Using the first image as the main image
    //   images: [
    //     'https://i.etsystatic.com/23883117/r/il/130519/2846519551/il_570xN.2846519551_ck9y.jpg',
    //     'https://i.etsystatic.com/24971278/r/il/ad3f68/3244436294/il_1080xN.3244436294_7jtm.jpg',
    //   ],
    //   category: 'Accessories',
    //   // Added a placeholder category
    //   subCategory: 'Bags',
    //   // Added a placeholder sub-category
    //   slug: 'product-name',
    //   // Added a slug
    //   videoLink: null,
    //   // Assuming no video link
    //   address: '123 Main Street, Anytown, USA',
    //   // Placeholder address
    //   latitude: 40.7128,
    //   // Placeholder latitude (New York City)
    //   longitude: -74.0060,
    //   // Placeholder longitude (New York City)
    //   isPremium: true,
    //   // Assuming the product is premium
    //   contact: '123-456-7890',
    //   // Placeholder contact
    //   country: 'USA',
    //   // Placeholder country
    //   state: 'New York',
    //   // Placeholder state
    //   city: 'New York City',
    //   // Placeholder city
    //   sellerName: 'Seller Name',
    //   sellerPicture:
    //       'https://plus.unsplash.com/premium_photo-1689977968861-9c91dbb16049?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8fDA%3D',
    //   rating: 10,
    // ),
    // ProductModel(
    //   id: 1,
    //   name: 'Product name',
    //   description:
    //       'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since.',
    //   price: 89.99,
    //   imageUrl:
    //       'https://i.etsystatic.com/23883117/r/il/130519/2846519551/il_570xN.2846519551_ck9y.jpg',
    //   // Using the first image as the main image
    //   images: [
    //     'https://i.etsystatic.com/23883117/r/il/130519/2846519551/il_570xN.2846519551_ck9y.jpg',
    //     'https://i.etsystatic.com/24971278/r/il/ad3f68/3244436294/il_1080xN.3244436294_7jtm.jpg',
    //   ],
    //   category: 'Accessories',
    //   // Added a placeholder category
    //   subCategory: 'Bags',
    //   // Added a placeholder sub-category
    //   slug: 'product-name',
    //   // Added a slug
    //   videoLink: null,
    //   // Assuming no video link
    //   address: '123 Main Street, Anytown, USA',
    //   // Placeholder address
    //   latitude: 40.7128,
    //   // Placeholder latitude (New York City)
    //   longitude: -74.0060,
    //   // Placeholder longitude (New York City)
    //   isPremium: true,
    //   // Assuming the product is premium
    //   contact: '123-456-7890',
    //   // Placeholder contact
    //   country: 'USA',
    //   // Placeholder country
    //   state: 'New York',
    //   // Placeholder state
    //   city: 'New York City',
    //   // Placeholder city
    //   sellerName: 'Seller Name',
    //   sellerPicture:
    //       'https://plus.unsplash.com/premium_photo-1689977968861-9c91dbb16049?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8fDA%3D',
    //   rating: 10,
    // ),
    // ProductModel(
    //   id: 1,
    //   name: 'Product name',
    //   description:
    //       'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since.',
    //   price: 89.99,
    //   imageUrl:
    //       'https://i.etsystatic.com/23883117/r/il/130519/2846519551/il_570xN.2846519551_ck9y.jpg',
    //   // Using the first image as the main image
    //   images: [
    //     'https://i.etsystatic.com/23883117/r/il/130519/2846519551/il_570xN.2846519551_ck9y.jpg',
    //     'https://i.etsystatic.com/24971278/r/il/ad3f68/3244436294/il_1080xN.3244436294_7jtm.jpg',
    //   ],
    //   category: 'Accessories',
    //   // Added a placeholder category
    //   subCategory: 'Bags',
    //   // Added a placeholder sub-category
    //   slug: 'product-name',
    //   // Added a slug
    //   videoLink: null,
    //   // Assuming no video link
    //   address: '123 Main Street, Anytown, USA',
    //   // Placeholder address
    //   latitude: 40.7128,
    //   // Placeholder latitude (New York City)
    //   longitude: -74.0060,
    //   // Placeholder longitude (New York City)
    //   isPremium: true,
    //   // Assuming the product is premium
    //   contact: '123-456-7890',
    //   // Placeholder contact
    //   country: 'USA',
    //   // Placeholder country
    //   state: 'New York',
    //   // Placeholder state
    //   city: 'New York City',
    //   // Placeholder city
    //   sellerName: 'Seller Name',
    //   sellerPicture:
    //       'https://plus.unsplash.com/premium_photo-1689977968861-9c91dbb16049?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8fDA%3D',
    //   rating: 10,
    // ),
    // ProductModel(
    //   id: 1,
    //   name: 'Product name',
    //   description:
    //       'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since.',
    //   price: 89.99,
    //   imageUrl:
    //       'https://i.etsystatic.com/23883117/r/il/130519/2846519551/il_570xN.2846519551_ck9y.jpg',
    //   // Using the first image as the main image
    //   images: [
    //     'https://i.etsystatic.com/23883117/r/il/130519/2846519551/il_570xN.2846519551_ck9y.jpg',
    //     'https://i.etsystatic.com/24971278/r/il/ad3f68/3244436294/il_1080xN.3244436294_7jtm.jpg',
    //   ],
    //   category: 'Accessories',
    //   // Added a placeholder category
    //   subCategory: 'Bags',
    //   // Added a placeholder sub-category
    //   slug: 'product-name',
    //   // Added a slug
    //   videoLink: null,
    //   // Assuming no video link
    //   address: '123 Main Street, Anytown, USA',
    //   // Placeholder address
    //   latitude: 40.7128,
    //   // Placeholder latitude (New York City)
    //   longitude: -74.0060,
    //   // Placeholder longitude (New York City)
    //   isPremium: true,
    //   // Assuming the product is premium
    //   contact: '123-456-7890',
    //   // Placeholder contact
    //   country: 'USA',
    //   // Placeholder country
    //   state: 'New York',
    //   // Placeholder state
    //   city: 'New York City',
    //   // Placeholder city
    //   sellerName: 'Seller Name',
    //   sellerPicture:
    //       'https://plus.unsplash.com/premium_photo-1689977968861-9c91dbb16049?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8fDA%3D',
    //   rating: 10,
    // ),
  ];


  static List<CategoryModel> categories = [
    // CategoryModel(
    //   icon: "https://firebasestorage.googleapis.com/v0/b/quitting-buddies-e5c5c.firebasestorage.app/o/categories%2Fboys-clothes.svg?alt=media&token=114f5e69-bcc4-42db-a00e-d62630d577bc",
    //   name: 'Boys clothes',
    // ),
    // CategoryModel(
    //   icon: "https://firebasestorage.googleapis.com/v0/b/quitting-buddies-e5c5c.firebasestorage.app/o/categories%2Fgirls-clothes.svg?alt=media&token=8a89dfe2-8910-42ff-8390-ab95a22236e5",
    //   name: 'Girls clothes',
    // ),
    // CategoryModel(
    //   icon: "https://firebasestorage.googleapis.com/v0/b/quitting-buddies-e5c5c.firebasestorage.app/o/categories%2Fgames.svg?alt=media&token=ead5cd1e-4f67-4d46-a823-39cfff47c764",
    //   name: 'Games & entertainment',
    // ),
    // CategoryModel(
    //   icon: "https://firebasestorage.googleapis.com/v0/b/quitting-buddies-e5c5c.firebasestorage.app/o/categories%2Fprams.svg?alt=media&token=55422cc8-45da-4f1b-8229-caeeef353ab8",
    //   name: 'Prams',
    // ),
    // CategoryModel(
    //   icon: "https://firebasestorage.googleapis.com/v0/b/quitting-buddies-e5c5c.firebasestorage.app/o/categories%2Fcar-seat.svg?alt=media&token=7a396dc6-3e5e-4e38-9a52-941f7cfb899f",
    //   name: 'Car seats',
    // ),
    // CategoryModel(
    //   icon: "https://firebasestorage.googleapis.com/v0/b/quitting-buddies-e5c5c.firebasestorage.app/o/categories%2Fbaby-product.svg?alt=media&token=8823ab64-aea8-4ccc-ac5b-f5545f64fca5",
    //   name: 'Baby products',
    // ),
    // CategoryModel(
    //   icon: "https://firebasestorage.googleapis.com/v0/b/quitting-buddies-e5c5c.firebasestorage.app/o/categories%2Ftoys.svg?alt=media&token=eb7119df-8503-493a-80aa-9d1223dc75c5",
    //   name: 'Toys',
    // ),
    // CategoryModel(
    //   icon: "https://firebasestorage.googleapis.com/v0/b/quitting-buddies-e5c5c.firebasestorage.app/o/categories%2Fchild-furniture.svg?alt=media&token=8aae4c3d-744b-43a4-be56-9082ec301723",
    //   name: "children's furniture",
    // ),
    // CategoryModel(
    //   icon: "https://firebasestorage.googleapis.com/v0/b/quitting-buddies-e5c5c.firebasestorage.app/o/categories%2Fremote_car.svg?alt=media&token=60509f0a-2893-403b-ae8e-6634b2778ccf",
    //   name: 'Outdoor toys and activities',
    // ),
    // // CategoryModel(
    // //   icon: "https://firebasestorage.googleapis.com/v0/b/quitting-buddies-e5c5c.firebasestorage.app/o/categories%2Fchild-furniture.png?alt=media&token=b87c3267-5835-4cc0-8307-d3cf95de62ac",
    // //   name: "children's furniture",
    // // ),
    // CategoryModel(
    //   icon: "https://firebasestorage.googleapis.com/v0/b/quitting-buddies-e5c5c.firebasestorage.app/o/categories%2Feducation.svg?alt=media&token=34a252d3-40f9-40b3-ad34-cb06129a2246",
    //   name: 'Education',
    // ),
  ];
}
