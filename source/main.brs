'********** Copyright 2015 Roku Corp.  All Rights Reserved. **********

SUB Main()
  showChannelSGScreen()
END SUB

SUB showChannelSGScreen()
  screen = CreateObject("roSGScreen")

  channelConfig = ParseJson(ReadAsciiFile("pkg:/source/channelConfig.json"))

  PRINT channelConfig

  m.global = screen.getGlobalNode()
  m.global.update(channelConfig, true)

  m.port = CreateObject("roMessagePort")
  screen.setMessagePort(m.port)
  scene = screen.CreateScene("MainScene")
  screen.show()

  WHILE(true)

    msg = wait(0, m.port)
    msgType = type(msg)

    IF msgType = "roSGScreenEvent"

      IF msg.isScreenClosed() THEN RETURN

    END IF

  END WHILE
END SUB
