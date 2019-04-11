SUB init()
  setVideo()

  m.timer = createObject("RoSGNode", "Timer")
  m.timer.duration = 0.001
  m.timer.ObserveField("fire", "focusVideo")
  m.timer.control = "start"
END SUB


SUB setVideo()
  m.top.update([{
    subtype: "Video"
    id: "videoNode"
    content: {
      subtype: "ContentNode"
      title: "Example Video"
      streamFormat: "hls"
      url: "https://roku.s.cpl.delvenetworks.com/media/59021fabe3b645968e382ac726cd6c7b/60b4a471ffb74809beb2f7d5a15b3193/roku_ep_111_segment_1_final-cc_mix_033015-a7ec8a288c4bcec001c118181c668de321108861.m3u8"
    }
    control: "play"
  }])
END SUB


SUB focusVideo()
  m.top.getChild(0).setFocus(true)
END SUB