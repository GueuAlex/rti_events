import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../models/event_model.dart';

final token = dotenv.env['API_TOKEN']!;

class RemoteService {
  //////////////////////////////////
  ///initialisation du client http
  var client = http.Client();
  //////////////////////////////
  ///////////////// base uri prod //////////////
  final baseUri = dotenv.env['BASE_URL']!;

///////////////// prod headers //////////////
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': token,
  };

  ///
  ///
  Future<dynamic> putSomethings({
    required String api,
    required Map<String, dynamic> data,
  }) async {
    ////////// parse our url /////////////////////
    var url = Uri.parse(baseUri + api);
    //var postEmail = {"email": email};
    ///////////// encode email to json objet/////////
    var payload = jsonEncode(data);
    // http request headers

    var response = await client.put(url, body: payload, headers: headers);
    debugPrint('------------------------${response.statusCode}');
    // print('------------------------///////////////////${response.body}');
    debugPrint(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      //Tontine tontine = tontineFromJson(response.body);
      var jsdecod = jsonDecode(response.body);
      //print('puuuuut : ${jsdecod['id']}');
      return jsdecod['id'];
    } else {
      return null;
    }
  }

  //////////////////////////////// get single user by id //////////////////////
  ///
  Future<http.Response> getTicket({required String uniqueCode}) async {
    var uri = Uri.parse('${baseUri}tickets/$uniqueCode');
    var response = await client.get(uri, headers: headers);
    //print('my user Dans remote /////////////////////////// : ${response.body}');
    debugPrint(
        'Dans remote////////////////////////////// : ${response.statusCode}');

    return response;
  }

  //////////////////////////////// get single user by id //////////////////////
  ///
  Future<http.Response> postSomethings(
      {required String api, required Map<String, dynamic> data}) async {
    ////////// parse our url /////////////////////

    var uri = Uri.parse('$baseUri$api');
    debugPrint(uri.toString());
    var payload = jsonEncode(data);
    var response = await client.post(
      uri,
      body: payload,
      headers: headers,
    );
    debugPrint(
        '$data was posted  /////////////////////////// : ${response.body}');
    debugPrint(
        'response statut code //////////////////// : ${response.statusCode}');

    return response;
  }

  /////// fetch all organizers
  ///le endpoints events renvie la list des events de façons paginé avec maximum 50 events par page.
  ///ameliore la fonction de sorte apprendre cela en compte
  ///l'appel cette fonction se fera également avec riverpod
  ///implement le provider pour le riverpod
  Future<List<EventModel>> getEvents() async {
    try {
      var uri = Uri.parse('${baseUri}events');
      var response = await client.get(uri, headers: headers);

      debugPrint('events response code ----------> : ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        var json = response.body;
        debugPrint('events response body ----------> : $json');
        List<EventModel> events = listEventModelFromJson(json);
        return events;
      } else {
        throw Exception(
            'Failed to load events. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching events: $e');
      throw Exception('Error fetching events: $e');
    }
  }
}
