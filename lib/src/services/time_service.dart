import 'package:supabase_flutter/supabase_flutter.dart';

class TimeService {
  final supabase = Supabase.instance.client;

  Future<void> clockIn(String jobId) async {
    await supabase.from('time_logs').insert({
      'job_id': jobId,
      'user_id': supabase.auth.currentUser!.id,
      'clock_in': DateTime.now().toIso8601String(),
    });
  }

  Future<void> clockOut(String logId) async {
    await supabase.from('time_logs').update({
      'clock_out': DateTime.now().toIso8601String(),
    }).eq('id', logId);
  }
}
