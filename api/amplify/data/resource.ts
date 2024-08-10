import { type ClientSchema, a, defineData } from '@aws-amplify/backend';

const schema = a.schema({
  SpeakerTalk: a
    .model({
      speakerId: a.id().required(),
      talkId: a.id().required(),
      speaker: a.belongsTo('Speaker', 'speakerId'),
      talk: a.belongsTo('Talk', 'talkId'),
    }),
  Talk: a
    .model({
      title: a.string(),
      description: a.string(),
      room: a.string(),
      startTime: a.datetime(),
      endTime: a.datetime(),
      isFavorite: a.boolean(),
      speakers: a.hasMany('SpeakerTalk', 'talkId'),
    }),
  Speaker: a
    .model({
      name: a.string(),
      title: a.string(),
      bio: a.string(),
      imageUrl: a.string(),
      links: a.hasMany('Link', 'speakerId'),
      talks: a.hasMany('SpeakerTalk', 'speakerId'),
    }),
  Link: a.model({
    type: a.enum(['twitter', 'github', 'linkedin', 'other']),
    url: a.string(),
    description: a.string(),
    speakerId: a.id(),
    speaker: a.belongsTo('Speaker', 'speakerId'),
  }),
}).authorization((allow) => [allow.guest()]);

export type Schema = ClientSchema<typeof schema>;
     
export const data = defineData({
  schema,
  authorizationModes: {
    defaultAuthorizationMode: 'identityPool',
  },
});

