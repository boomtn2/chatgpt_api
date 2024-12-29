import 'package:supabase_flutter/supabase_flutter.dart';

import 'model.dart';

class SupbaseHelper {
  static const supabaseUrl = 'https://atdqiebvklryfwmcajtw.supabase.co';
  static const supabaseKey =
  static Future insert(Truyen truyen, SupabaseClient supabase) async {
    await supabase.from('dbtruyen').insert(truyen.getJson());
  }

  static Future update(Truyen truyen, SupabaseClient supabase) async {
    await supabase
        .from('dbtruyen')
        .update(truyen.getJsonUpdate())
        .eq('id', truyen.id);
  }

  static Future delete(Truyen truyen, SupabaseClient supabase) async {
    await supabase.from('dbtruyen').delete().eq('id', truyen.id);
  }

  static Future<List<String>> getRelatedCategory(
      List embedding, SupabaseClient supabase) async {
    List<String> list = [];
    await supabase.rpc('get_related_category',
        params: {'embedding': embedding}).withConverter(
      (data) {
        if (data is List) {
          for (var element in data) {
            list.add('${element['name']}');
          }
        }
      },
    );

    return list;
  }

  static Future<List<Truyen>> getTruyenFillCategory(
      List<String> listCategory, SupabaseClient supabase) async {
    List<Truyen> data = [];
    await supabase.rpc('get_truyen_fill_category',
        params: {'input_category_array': listCategory}).withConverter((users) {
      if (users is List) {
        for (var element in users) {
          data.add(Truyen.fromJson(element as Map));
        }
      }
    });
    return data;
  }

  //   void fetchData() async {
  //   supabaseQueryBuilder = await supabase
  //       .from('dbtruyen')
  //       .select('id, title')
  //       .isFilter('embedding', null)
  //       // .like('id', 'than-dieu-hiep-lu-tap-6.sna')
  //       .range(0, 1)
  //       .withConverter(
  //         (data) {},
  //       );

  //   //===========related truyen

  //   // final data = await supabase.rpc('get_related', params: {
  //   //   'id_truyen': 'than-dieu-hiep-lu-tap-5.sna',
  //   //   'embedding':
  // }
}
