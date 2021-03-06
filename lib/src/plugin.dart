import 'dart:core';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:flutterjanus/flutterjanus.dart';

class Plugin {
  Map<String, dynamic> webrtcStuff = {
    'started': false,
    'myStream': null,
    'streamExternal': false,
    'remoteStream': null,
    'mySdp': null,
    'mediaConstraints': null,
    'pc': null,
    'dataChannel': {},
    'dtmfSender': null,
    'trickle': true,
    'iceDone': false,
    'volume': {'value': null, 'timer': null},
    'bitrate': {
      'value': null,
      'bsnow': null,
      'bsbefore': null,
      'tsnow': null,
      'tsbefore': null,
      'timer': null
    }
  };

  bool detached;

  final Session session;
  final Callbacks callbacks;
  final String plugin;
  final String handleId;
  final String handleToken;

  Plugin(
      {this.session,
      this.plugin,
      this.handleId,
      this.handleToken,
      this.callbacks});

  getId() => handleId;
  getPlugin() => plugin;
  getVolume() => this.session.getVolume(this.handleId, true);
  getRemoteVolume() => this.session.getVolume(this.handleId, true);
  getLocalVolume() => this.session.getVolume(this.handleId, false);
  isAudioMuted() => this.session.isMuted(this.handleId, false);
  muteAudio() => this.session.mute(this.handleId, false, true);
  unmuteAudio() => this.session.mute(this.handleId, false, false);
  isVideoMuted() => this.session.isMuted(this.handleId, true);
  muteVideo() => this.session.mute(this.handleId, true, true);
  unmuteVideo() => this.session.mute(this.handleId, true, false);
  getBitrate() => this.session.getBitrate(this.handleId);
  send(callbacks) => this.session.sendMessage(this.handleId, callbacks);
  data(callbacks) => this.session.sendData(this.handleId, callbacks);
  dtmf(callbacks) => this.session.sendDtmf(this.handleId, callbacks);

  consentDialog(bool state) => callbacks.consentDialog(state);
  iceState(bool state) => callbacks.iceState(state);
  mediaState(mediaType, mediaReciving) =>
      callbacks.mediaState(mediaType, mediaReciving);
  webrtcState(bool state, [reason]) => callbacks.webrtcState(state, [reason]);
  slowLink(uplink, lost) => callbacks.slowLink(uplink, lost);
  onmessage(data, jsep) => callbacks.onmessage(data, jsep);
  createOffer({Callbacks callbacks}) =>
      this.session.prepareWebrtc(this.handleId, true, callbacks);
  createAnswer(callbacks) =>
      this.session.prepareWebrtc(this.handleId, false, callbacks);
  handleRemoteJsep(callbacks) =>
      this.session.prepareWebrtcPeer(this.handleId, callbacks);
  onlocalstream(MediaStream stream) => callbacks.onlocalstream(stream);
  onremotestream(MediaStream stream) => callbacks.onremotestream(stream);
  ondata(event, data) => callbacks.ondata(event, data);
  ondataopen(label) => callbacks.ondataopen(label);
  oncleanup() => callbacks.oncleanup();
  ondetached() => callbacks.ondetached();
  hangup(sendRequest) =>
      this.session.cleanupWebrtc(this.handleId, sendRequest == true);
  detach(callbacks) => this.session.destroyHandle(this.handleId, callbacks);
}
