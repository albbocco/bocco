import { NextRequest, NextResponse } from 'next/server';
import { supabase } from '@/lib/supabase';

export const dynamic = 'force-dynamic';

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const { userId, videoId, audioUrl } = body;

    // Check credits (1 credit for lip-sync)
    const { data: credits } = await supabase
      .from('credits')
      .select('balance')
      .eq('user_id', userId)
      .single();

    if (!credits || credits.balance < 1) {
      return NextResponse.json({ error: 'Insufficient credits' }, { status: 400 });
    }

    // Get video
    const { data: video } = await supabase
      .from('videos')
      .select('video_url')
      .eq('id', videoId)
      .eq('user_id', userId)
      .single();

    if (!video?.video_url) {
      return NextResponse.json({ error: 'Video not found' }, { status: 404 });
    }

    // Update video status
    await supabase
      .from('videos')
      .update({ status: 'lip_sync' })
      .eq('id', videoId);

    // Call VEED API (à compléter quand la clé arrive)
    // const veedKey = process.env.VEED_API_KEY;
    // const veedResponse = await fetch('https://api.veed.io/lip-sync', {...});

    // Pour l'instant, simulation
    await new Promise(resolve => setTimeout(resolve, 2000));

    // Update video with final URL
    await supabase
      .from('videos')
      .update({
        status: 'completed',
        // video_url: finalVideoUrl,
      })
      .eq('id', videoId);

    // Deduct credit
    await supabase
      .from('credits')
      .update({ balance: credits.balance - 1 })
      .eq('user_id', userId);

    // Add transaction
    await supabase.from('credit_transactions').insert({
      user_id: userId,
      amount: -1,
      type: 'usage',
      description: 'Lip-sync (VEED)',
    });

    return NextResponse.json({
      success: true,
      message: 'Lip-sync completed (VEED API à intégrer)',
    });
  } catch (error) {
    console.error('Lip-sync error:', error);
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 });
  }
}
