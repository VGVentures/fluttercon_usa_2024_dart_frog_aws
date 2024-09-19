/// The cache key for the speakers cache.
const speakersCacheKey = 'speakers';

/// The cache key for an individual cached speaker.
String speakerCacheKey(String id) => 'speaker_$id';

/// The cache key for a speaker talks given a [talkId].
String speakerTalksCacheKey(String talkIds) => 'speaker_talks_$talkIds';

/// The cache key for the talks cache.
const talksCacheKey = 'talks';

/// The cache key for the favorites corresponding to a [userId].
String favoritesCacheKey(String userId) => 'favorites_$userId';

/// The cache key for an individual cached talk.
String talkCacheKey(String id) => 'talk_$id';
