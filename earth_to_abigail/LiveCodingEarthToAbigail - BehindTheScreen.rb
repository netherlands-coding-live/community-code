# Live Coding with Earth to Abigail

# The voice samples used during the performance are taken
# from YouTube videos created by Ted Nelson.

# All sample names written in all caps are samples from my own collection, so
# you'll need to replace them with other samples if you'd like to play around with the code :)


UNSORTED_LIST = [96, 62, 98, 69, 84, 76, 82, 64, 74, 77, 94, 67, 53, 60, 55,
                 57, 81, 89, 79, 72, 52, 70, 58, 86]


define :bubble_sort do |list, amp, sleep|
  
  arr = list.dup
  swapped = false
  r = arr.length - 2
  
  use_synth :sine
  while true
    for i in 0..r
      play arr[i], amp: rrand(0.4, amp), release: 0.1,
        decay: 0.1, pan: [-1, 1].tick, cutoff: 80
      sleep sleep
      if arr[i] > arr[i+1]
        arr[i], arr[i+1] = arr[i+1], arr[i]
        swapped = true if !swapped
        play arr[i], amp: amp, release: 0.1,
          pan: [-1, 1].tick, cutoff: 80
        sleep sleep
      end
    end
    
    swapped ? swapped = false : break
  end
end

use_bpm 90

live_loop :time do
  sleep 1
end

with_fx :reverb, room: 0.9 do
  
  live_loop :sorting_sounds, sync: :harmonies do stop
    bubble_sort(UNSORTED_LIST, 0.5, 0.25)
  end
  
  live_loop :harmonies, sync: :pulsing do stop
    cue "speak_Ted"
    chords = [(chord :d4, :minor), (chord :f3, :major, invert: 2),
              (chord, :c4, :major), (chord :g3, :minor, invert: 2)]
    chords.each do |ch|
      with_fx :slicer, phase: [0.25, 0.5].choose, phase_slide: 8 do |sl|
        synth :beep, note: ch, sustain: 6, release: 1,
          decay: 1, attack: 0.2, amp: 0.7
        control sl, phase: [0.25, 0.5].choose
        sleep 8
      end
    end
  end
  
  live_loop :low_vibrations, sync: :harmonies do stop
    notes = [:d1, :f1, :c1, :g1]
    notes.each do |n|
      in_thread do
        p = synth :prophet, note: n, amp: 0,
          sustain: 8, cutoff: 60, cutoff_slide: 8
        control p, cutoff: 110
        32.times do
          control p, note: (octs n, 3).tick
          sleep 0.25
        end
      end
      synth :dsaw, cutoff: 50, note: n, sustain: 6,
        release: 1, attack: 1
      sleep 8
    end
  end
  
end

with_fx :reverb, room: 0.5 do
  with_fx :compressor, pre_amp: 3 do
    
    live_loop :Ted_Nelson_speaks, sync: :time do stop
      sync "speak_Ted"
      t = TED.tick
      with_fx :echo, mix: 0.3, decay: 0.5 do
        sample t, amp: 1.2, attack: 0.5, release: 0.5
        sleep sample_duration(t) + rrand_i(16, 30)
      end
    end
    
    
    live_loop :pulsing, sync: :sorting_sounds do stop
      tick
      if look % 7 == 0
        sleep 16
      else
        
        in_thread do
          with_fx :bitcrusher, sample_rate: 1000, sample_rate_slide: 8 do |bc|
            sample DL[7], amp: 0, beat_stretch: 8
            control bc, sample_rate: 5000
            sleep 8
          end
        end
        in_thread do
          2.times do
            8.times do
              sample DL[7], amp: rrand(0.8, 1.2), onset: pick,
                rate: [1,1,1,1,1,-1].choose, pan: rrand(-1, 1)
              sleep [0.5, 1].choose
            end
          end
        end
        in_thread do
          4.times do
            sample :bd_haus, cutoff: 90, amp: 1.2
            sleep 1.75
            sample :bd_haus, cutoff: 90, amp: 1 if one_in(3)
            sleep 0.25
          end
        end
        at [0.25, 0.75, 1.5, 2.25, 2.5, 2.75, 3.5, 4, 4.25, 4.75] do
          sample HH_CLOSED[0], rate: 2, amp: rrand(0.8, 1.2)
        end
        sleep 4
      end
    end
    
  end
end





