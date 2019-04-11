'********** Copyright 2015 Roku Corp.  All Rights Reserved. **********

sub Main()
	showChannelSGScreen()
end sub

sub showChannelSGScreen()
	screen = CreateObject("roSGScreen")

  channelConfig = ParseJson(ReadAsciiFile("pkg:/source/channelConfig.json"))

  print channelConfig

  m.global = screen.getGlobalNode()
  m.global.update(channelConfig, true)

	m.port = CreateObject("roMessagePort")
	screen.setMessagePort(m.port)
	scene = screen.CreateScene("MainScene")
	screen.show()

	while(true)

		msg = wait(0, m.port)
		msgType = type(msg)

		if msgType = "roSGScreenEvent"

			if msg.isScreenClosed() then return

		end if

	end while
end sub
