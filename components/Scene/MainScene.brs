
SUB init()

  ' Example of using update like set fields but also creating a node for
  ' the dialog field by leveraging subtype and also creating a child rowList
  ' buy using both the children key and setting using the addFields param as true.
  m.top.update(m.global.configs.Screens.MainScene.initConfig, true)

  ' Here is an example of the object being used.
  ' {
  '   id            : "tutorialScene"
  '   backgroundURI : "pkg:/images/rsgetbg.jpg"
  '   dialog        : {
  '     subtype:      : "ProgressDialog"
  '     backgroundUri : "pkg:/images/sgetdialogbg.9.png"
  '     title         : "Loading SubReddits For Roku"
  '   },
  '   children: [{
  '     subtype                 : "RowList"
  '     id                      : "RedditList"
  '     translation             : [ 100, 40 ]
  '     itemComponentName       : "RowListItem"
  '     numRows                 : 2
  '     itemSize                : [ 536 * 3, 308 ]
  '     rowItemSize             : [ [536, 308] ]
  '     itemSpacing             : [ 0, 40 ]
  '     showRowLabel            : [ true ]
  '     showRowCounter          : [ true ]
  '     drawFocusFeedback       : false
  '     vertFocusAnimationStyle : "fixedFocusWrap"
  '     rowFocusAnimationStyle  : "fixedFocusWrap"
  '   }]
  ' }

  m.RedditList = m.top.findNode("RedditList")
  m.RedditList.observeField("rowItemSelected", "onRowItemSelected")

  m.task = CreateObject("roSGNode", "RedditTask")
  m.task.observeField("response", "onRedditTaskResponse")
  m.task.control = "RUN"
END SUB


SUB onRedditTaskResponse(event)
  PRINT "onRedditTaskResponse"
  m.top.dialog.close = true

  m.RedditList.content = event.getData()
  m.RedditList.setFocus(true)
END SUB


SUB onRowItemSelected()
  m.videoExample = m.top.createChild("videoExample")
END SUB


SUB removeReference(key AS STRING) AS BOOLEAN
  IF "roSGNode" = type(m[key]) AND INVALID <> m[key].getParent()
    m[key].getParent().removeChild(m[key])
  END IF

  m[key] = INVALID
END SUB


FUNCTION onKeyEvent(key AS STRING, press AS BOOLEAN) AS BOOLEAN
  IF press
    IF "back" = key AND INVALID <> m.videoExample
      removeReference("videoExample")
      m.RedditList.setFocus(true)
      RETURN true
    END IF
  END IF
END FUNCTION