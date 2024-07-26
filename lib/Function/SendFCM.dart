import 'dart:convert';
import 'package:http/http.dart' as http;

class SendFCM {
  void call({required String title, required String body, String topic = "all"}) async{
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ya29.c.c0ASRK0GZOgOJZdZ0HOm0OWuz3T-_ojcuNBYX0E_inZxduwAAtzW9HuBT5kvPpau123e4OklHdSLSVjDVCMLmf2v0mo8fBdntto-2Q0ulu5BKfiWSb8QBJg7W3y4upGSogMkYwvqD9TdjfwFfT5sltX8Ndsw1waUhwgN6KEUasC6jNFYIJHfdHYf9pn20n0-MNd98Llb3fVHtu9_b1iUiVTUEH6rxgH_LP0xjD8ogA_BuaUpwHXT87gL7ytTi7kMctw3dCws7nmWRAbkS2fgeqjQP9Xm0sii27apvdSOwWkAG6-YawthuZpqQQbgCCWobgQqw1aQdqXLWKv-bbGIBZNF4HoT4M03HukkoPiTv4BE5GcLuF8nH6iEcAH385CIvwkv-3c9b66opZrwMFf47ugqFrya-o_nReYbzwq5gqWs5MzaYtiYR9In44rRuVsgWYx-3V17vFwkdZmgJUuBxmkR_3xehiSbRcbhq5bqokj1b_t6d9B0FMt94m54jB10p8bnfQ-RcjY0YFZBZnh0u0dO5v2ryvimY_tWy9xrmIydjniyeJkQfXIBk1wlgod-m_-BqIjwMa_wdf-W4lsa47mk86BYRFmySQ3W4qco9nwgZFzsBfIsSez7Jpbxzk51f7y32kwS8XawJsicX4Vb_9o145aaomuFSecsny3t6v-n1Sucimnp51J8dYaj_t8e6pF1gYeQReRtQRYO32JxYQw5tSfr8eFxiv19wph2rMFyUXMUbJMd-XZWWjznXju1z3cR4brJgarVhQ9tVt5xjsYoOnRurIMWnttVyU3X1UUUoW9wiVXlxlXUrn7MrziIl5rcRJ8zpBgM-qeiQ120eUozRpWjWZhjQz1BUmkpIgYFuqfgVOVJml0nlJ4rs95eObQIj82rpYIlu6YJ_cYomv4af3-5u5jO1MsFuXW1WxJm3rm57QOQ4nkizsIjJ_7M9OUdjIcyyjYJqi4BVFQ3wMO3w4uRcwdM-wkp_pQ2yfF4RuwqB0jJ9sob1'
    };
    var request = http.Request('POST', Uri.parse('https://fcm.googleapis.com/v1/projects/blood-donating-app-2c666/messages:send'));
    request.body = json.encode({
      "message": {
        "topic": topic,
        "notification": {
          "title": title,
          "body": body
        }
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }
}