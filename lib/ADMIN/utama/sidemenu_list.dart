import 'package:flutter/material.dart';
import 'package:myapp/ADMIN/page/akun.dart';
import 'package:myapp/ADMIN/page/beritaPromo.dart';
import 'package:myapp/ADMIN/page/hapusBarang.dart';
import 'package:myapp/ADMIN/page/hapusPromo.dart';
import 'package:myapp/ADMIN/page/kategoriBarang.dart';
import 'package:myapp/ADMIN/page/transaksi.dart';
import 'package:myapp/ADMIN/utama/home.dart';
import 'package:myapp/USER/Screen/WelcomeScreen.dart';

class SidemenuList extends StatefulWidget {
  const SidemenuList({super.key});

  @override
  State<SidemenuList> createState() => _SidemenuListState();
}

class _SidemenuListState extends State<SidemenuList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(
              maxRadius: 30,
              child: Icon(Icons.vpn_key, color: Colors.black),
              backgroundColor: Color.fromRGBO(243, 162, 11, 1),
            ),
            title: const Text(
              'Primery',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: const Text(
              'Admin',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white70,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeAdm()),
              );
            },
          ),
          const SizedBox(height: 20),
          const Divider(
              color: Colors.white, thickness: 1, height: 10, indent: 12),
          const SizedBox(height: 50),
          DropdownDecoration(
            name: "Barang & Kategori",
            icon: Icons.category_outlined,
            items: [
              DropdownMenuItem(
                child: Text("Tambah"),
                value: "tambah",
              ),
              DropdownMenuItem(
                child: Text("Hapus"),
                value: "hapus",
              ),
            ],
            onSelected: (value) {
              if (value == "tambah") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Kategoribarang()), // Ganti dengan halaman tambah kategori
                );
              } else if (value == "hapus") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HapusBarang()), // Ganti dengan halaman hapus kategori
                );
              }
            },
          ),
          const SizedBox(height: 40),
          DropdownDecoration(
            name: "Berita Promo",
            icon: Icons.newspaper_outlined,
            items: [
              DropdownMenuItem(
                child: Text("Tambah"),
                value: "tambah",
              ),
              DropdownMenuItem(
                child: Text("Hapus"),
                value: "hapus",
              ),
            ],
            onSelected: (value) {
              if (value == "tambah") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Beritapromo()), // Ganti dengan halaman tambah berita promo
                );
              } else if (value == "hapus") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HapusBeritaPromo()), // Ganti dengan halaman hapus berita promo
                );
              }
            },
          ),
          const SizedBox(height: 40),
          ButtonDecoration(
            name: "Transaksi",
            icon: Icons.payments_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Transaksi()),
              );
            },
          ),
          const SizedBox(height: 40),
          ButtonDecoration(
            name: "Akun",
            icon: Icons.person_2_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AkunPage()),
              );
            },
          ),
          const SizedBox(height: 40),
          ButtonDecoration(
            name: "Logout",
            icon: Icons.logout_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget ButtonDecoration({
    required String name,
    required IconData icon,
    required VoidCallback onTap, 
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(icon, size: 30, color: Color.fromRGBO(243, 162, 11, 1)),
          const SizedBox(width: 20),
          Text(
            name,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget DropdownDecoration({
    required String name,
    required IconData icon,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onSelected,
  }) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Icon(icon, size: 30, color: Color.fromRGBO(243, 162, 11, 1)),
        const SizedBox(width: 20),
        DropdownButton<String>(
          hint: Text(
            name,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
          items: items,
          onChanged: onSelected,
          underline: SizedBox(),
          dropdownColor: Colors.black,
          iconEnabledColor: Color.fromRGBO(243, 162, 11, 1),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
