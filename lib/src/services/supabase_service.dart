import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchJobs(String orgId) async {
    final res = await supabase
        .from('jobs')
        .select('*, sites(*)')
        .eq('organization_id', orgId)
        .order('scheduled_at', ascending: true)
        .limit(100)
        .execute();

    if (res.error != null) throw res.error!;
    return List<Map<String, dynamic>>.from(res.data as List);
  }
}
