import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/shared/images.dart';
import '../shared/global.dart';
import '../widgets/card_laporan.dart';
import 'add_score.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LaporanHasilBelajarPage extends StatefulWidget {
  const LaporanHasilBelajarPage({Key? key}) : super(key: key);

  @override
  _LaporanHasilBelajarPageState createState() => _LaporanHasilBelajarPageState();
}

class _LaporanHasilBelajarPageState extends State<LaporanHasilBelajarPage> {
  late List<dynamic> laporanItems = [];
  late String expectedHours = '';
  late String actualHours = '';
  late String totalSKS = '';
  late String StartProductiveHour = '';
  late String EndProductiveHour = '';
  bool _isLoading = true;
  bool _hasEnteredGrade = false;

  @override
  void initState() {
    super.initState();
    fetchLaporanData();
  }

  Future<void> fetchLaporanData() async {
    try {
      var url = 'http://$ipUrl/users/$email/learning-report/semester/$idSemester';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final fetchedData = jsonResponse['data'];

        print(fetchedData);

        setState(() {
          expectedHours = fetchedData['hourExpected'].toString();
          actualHours = fetchedData['hourImplemented'].toString();
          totalSKS = fetchedData['totalSKS'].toString();
          laporanItems = fetchedData['mataKuliah'];
          StartProductiveHour = fetchedData['productiveTime']['startTime'];
          EndProductiveHour = fetchedData['productiveTime']['endTime'];

          _isLoading = false;
        });
        print (laporanItems);

        if (laporanItems[1]['dataMatakuliah']['subjectGrade'] != null){
          setState(() {
            _hasEnteredGrade = true;
          });
        }

        print(laporanItems);
        print(_hasEnteredGrade);

      } else {
        throw Exception('Failed to fetch profile data');
      }
    } catch (error) {
      print('Error fetching profile data: $error');
      throw Exception('Failed to fetch profile data');
    }
  }

  String formatedJamBelajar(String actual, String expected) {
    String jamBelajar;

    jamBelajar = actual + '/' + expected;

    return jamBelajar;
  }

  String formatedText(String actual, String expected) {
    String jamBelajar;

    jamBelajar = actual + '/' + expected;

    return jamBelajar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Laporan Hasil Belajar',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(5),
            ),
            width: 25,
            height: 25,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.add,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  InputNilaiPage(laporanItems: laporanItems)),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 30),
        ],
      ),
      body:
      _isLoading ?
      Center(child: CircularProgressIndicator())
      : SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Image.asset(
                image_laporan_akhir,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Cek laporan belajarmu!',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  color: darkBlue,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 90,
              color: softBlue,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total jam belajar:',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: actualHours,
                                style: TextStyle(fontSize: 25),
                              ),
                              TextSpan(
                                text: '/',
                                style: TextStyle(fontSize: 16),
                              ),
                              TextSpan(
                                text: expectedHours,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Jumlah SKS:',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: totalSKS,
                                style: TextStyle(fontSize: 25),
                              ),
                              TextSpan(
                                text: ' sks',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Waktu produktif:',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: StartProductiveHour ,
                                style: TextStyle(fontSize: 18),
                              ),
                              TextSpan(
                                text: '-',
                                style: TextStyle(fontSize: 20),
                              ),
                              TextSpan(
                                text: EndProductiveHour,
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
                child:

                laporanItems.isEmpty || laporanItems == [] ?
                  Center(child: Text("No Schedule Yet, Create new!"))
                    : ListView.builder(
                        itemCount: laporanItems.length,
                        itemBuilder: (context, index) {
                          final item = laporanItems[index]['dataMatakuliah'];
                          return Column(
                            children: [
                              _hasEnteredGrade ?
                              LaporanItem(
                                matkul: item['subjectName'],
                                jamBelajar: formatedJamBelajar(laporanItems[index]['hourImplemented'].toString(), laporanItems[index]['hourExpected'].toString()),
                                color: Color(item['subjectColor']),
                                nilai: item['subjectGrade'],
                                text: laporanItems[index]['subjectNotes'],
                              )
                                : LaporanItem(
                                    matkul: item['subjectName'],
                                    jamBelajar: formatedJamBelajar(laporanItems[index]['hourImplemented'].toString(), laporanItems[index]['hourExpected'].toString()),
                                    color: Color(item['subjectColor']),
                                  ),
                              Divider(),
                            ],
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
