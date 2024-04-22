import 'package:construction/customer_screens/ProfileLanding.dart';
import 'package:construction/customer_screens/login.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class Home extends StatefulWidget {
  final String userName;

  const Home({Key? key, required this.userName}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, dynamic>> items = [
    {
      'image': 'https://a0.muscache.com/im/pictures/fe49a8d8-18c1-43da-9935-f12dd279a4a2.jpg?im_w=720',
      'price': '₹ 10,50,000',
      'rating': '4.58',
    },
    {
      'image': 'https://img.freepik.com/free-photo/modern-residential-district-with-green-roof-balcony-generated-by-ai_188544-10276.jpg?size=626&ext=jpg&ga=GA1.1.2082370165.1710720000&semt=ais',
      'price': '₹ 25,20,000',
      'rating': '4.78',
    },
    {
      'image': 'https://images.ctfassets.net/n2ifzifcqscw/6hIAc3H1KQ0LS6WZHkMhkv/658de9a8d340be3e9d10ee20234ae333/types-of-houses-hero.jpeg',
      'price': '₹ 17,50,000',
      'rating': '3.98',
    },
    {
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0E8ypgVNBQWPAsNwRfTbPPCW_EDxg2S_svg&usqp=CAU',
      'price': '₹ 20,00,000',
      'rating': '4.08',
    },
    {
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIatMIGUvxCiIfjtfXc66QiUmI4rdpTJdOBg&usqp=CAU',
      'price': '₹ 10,000,000',
      'rating': '4.88',
    },

    // Add more items as needed
  ];
  void _launchEmail(String email, String subject, String body) async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (await canLaunch(_emailLaunchUri.toString())) {
      await launch(_emailLaunchUri.toString());
    } else {
      throw 'Could not launch email';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile(userName : widget.userName)));
                },
                icon: Icon(Icons.person),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                ClipOval(
                  child: Image(
                    image: AssetImage('assets/profile.jpg'),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Text('Dharani A K'),
                Text('+91 8438005578 '),
                Text('dharani@gmail.com'),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: TextButton(
                            onPressed: () {
                              _launchEmail('kiruthiyaashree@gmail.com', 'Hello', 'This is a test email.');
                            },
                            child: Text(
                              'Message',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(0),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Call',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.all(25),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10), // Specify the desired border radius
                              child: Image.network(
                                items[index]['image'],
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  items[index]['price'],
                                  style: TextStyle(fontSize: 15),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 20,
                                      color: Colors.yellow,
                                    ),
                                    Text(
                                      items[index]['rating'],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  // On button press action
                                },
                                child: Text('See more'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
