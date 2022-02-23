import 'dart:math';

class Label {
  static List<String> loseLabelList = [
    "That was. Unlucky...",
    "Try again next time!",
    "That was close.",
    "Better luck next time!",
    "Actually, that was a nice try",
    "At this moment. Lady fortuna is not on your side.",
    "Never heard of it?",
    "Nice try for a 5 years old.",
    "We thought you were better than that...",
    "Oh, come on! That was not that hard.",
    "Oh, come on! That was easy, right?",
    "Oh, come on! That was not even hard",
    "Sorry, but did you even try?",
    "Sorry, can you at least try?",
    "Putting a bit of effort would not hurt. Pretty sure",
    "Yeah, right it was that word.",
    "Right, you thought about that did you?",
    "Well, you lost.",
    "Well, that was disappointing.",
    "I am sad to inform you that you just lost.",
    "Oh, well, you lost.",
    "I guess you just lost.",
    "Nice try! ...... NOT",
    "Congratulations, you LOST!",
    "Please don't be offended but you just lost",
    // Sound effects
    "[Sad trombone]",
    "[Laughters in the background]",
    "[Crowd groans]",
    "[Singing] Hello darkness my old friend.....",
    "[People holding back their laughters]",
    // Sarcastic
    "Did we not explain the rule well enough?",
    "Pretty sure we written a rule about how to play this.",
    "Please read the rule and come back.",
    "Hellooo! Maybe you can put a little bit of effort to this.",
    "God. You. Are. So. Bad.",
    "Congratulations! You don't win!",
    "That was horrible, to be honest with you",
  ];
  static List<String> loseDuplicateLabelList = [];
  static List<String> winLabelList = [
    "Well done!",
    "Good job!",
    "Perfect",
    "Easy win!",
    "VIOLA! You did it! YES, you just did it!",
    "Congratulations! You win!",
    "Yeay! You did it!",
    "My god, you are good.",
    "Hooray! Hooray! Hooray!",
    "Well that was easy right?",
    "Come on, it was not that hard right?",
    "Of course you won.",
    "Easy peasy, lemon squeazy",
    "That was a piece of cake",
    "Easy as that my friend!",
    "Well, that was effortless",
    "You are not cheating aren't you?",
    "Hmmmmm... You are too good... Suspicious...",
    "No, no, no, no, no. You are definitely cheating.",
    "You are simply too good.",
    "Ok, nice.",
    "Glad that you don't lose.",
    "Glad that you win.",
    // Sound effects
    "[Crowd applauds]",
    "[People doing standing ovations]",
    "[Singing] We are the champions, my frieeend!",
    "[Singing] THE CHAMPIOOOOOONS!!"
    //
    "Now playing: Queen - We Are the Champions",
    "VICTORIOUUUUUUUUUS!!!",
    "Wow, you win, what a surprise.",
    "BAM! Just like that.",
    "BOOM! Done.",
    "Can you at least pretend to struggle??",
    "We'll make it harder for you next time, just wait.",
    "Take a deep breath, you did it. Congrats",
    "See? Easy right?",
    "Glad you remember that word."
  ];

  static String get randomWinLabel =>
      winLabelList[Random().nextInt(winLabelList.length)];
  static String get randomLoseLabel =>
      loseLabelList[Random().nextInt(loseLabelList.length)];
}
