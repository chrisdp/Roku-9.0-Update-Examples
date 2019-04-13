
SUB init()
  m.loaded = false
  m.currentExampleScreen = INVALID

  ' Example of using update like set fields but also creating a node for
  ' the dialog field by leveraging subtype and also creating a child rowList
  ' buy using the children key.
  m.top.update(m.global.configs.Screens.MainScene.initConfig)

  ' Here is an example of the object being used.
  ' {
  '   "id": "tutorialScene",
  '   "backgroundURI": "pkg:/images/rsgetbg.jpg",
  '   "dialog": {
  '     "subtype": "ProgressDialog",
  '     "backgroundUri": "pkg:/images/sgetdialogbg.9.png",
  '     "title": "Loading SubReddits For Roku"
  '   },
  '   "children": [{
  '     "subtype": "Group",
  '     "id": "MainView",
  '     "children": [{
  '       "subtype": "RowList",
  '       "id": "RedditList",
  '       "translation": [100, 40],
  '       "itemComponentName": "RowListItem",
  '       "numRows": 2,
  '       "itemSize": [1608, 308],
  '       "rowItemSize": [
  '         [536, 308]
  '       ],
  '       "itemSpacing": [0, 40],
  '       "showRowLabel": [true],
  '       "showRowCounter": [true],
  '       "drawFocusFeedback": false,
  '       "vertFocusAnimationStyle": "floatingFocus",
  '       "rowFocusAnimationStyle": "fixedFocusWrap"
  '     }, {
  '       "subtype": "LabelList",
  '       "id": "ExampleList",
  '       "translation": [100, 750],
  '       "numRows": 5,
  '       "itemSize": [1608, 50],
  '       "itemSpacing": [0, 10],
  '       "vertFocusAnimationStyle": "floatingFocus",
  '       "visible": false,
  '       "content": {
  '         "subtype": "ContentNode",
  '         "children": [{
  '           "subtype": "ContentNode",
  '           "title": "Video Example"
  '         }, {
  '           "subtype": "ContentNode",
  '           "title": "Better Scrollable Text Example"
  '         }]
  '       }
  '     }]
  '   }]
  ' }
  m.MainView = m.top.findNode("MainView")

  m.RedditList = m.top.findNode("RedditList")
  m.RedditList.observeField("rowItemSelected", "onRedditListItemSelected")

  m.ExampleList = m.top.findNode("ExampleList")
  m.ExampleList.observeField("itemSelected", "onExampleListItemSelected")

  m.task = CreateObject("roSGNode", "RedditTask")
  m.task.observeField("response", "onRedditTaskResponse")
  m.task.control = "RUN"
END SUB


SUB onRedditTaskResponse(event)
  PRINT "onRedditTaskResponse"
  m.top.dialog.close = true

  m.RedditList.content = event.getData()
  m.RedditList.setFocus(true)

  m.ExampleList.visible = true
  m.loaded = true
END SUB


SUB onRedditListItemSelected()
  openExampleView("videoView")
END SUB


SUB onExampleListItemSelected(event)
  openExampleView(event.getRoSGNode().content.getChild(event.getData()).title.Replace(" ", ""))
  PRINT event.getRoSGNode().content.getChild(event.getData()).title
END SUB


SUB openExampleView(viewName AS STRING)
  PRINT "openExampleView: ", viewName

  IF 0 < viewName.len()
    IF INVALID = m[viewName]
      IF INVALID <> m.currentExampleScreen
        removeReference(m.currentExampleScreen)
      END IF

      m[viewName] = m.top.createChild(viewName)
      m.currentExampleScreen = viewName
      m.MainView.visible = false
    END IF
  END IF
END SUB


SUB removeReference(key AS STRING) AS BOOLEAN
  IF "roSGNode" = type(m[key]) AND INVALID <> m[key].getParent()
    m[key].getParent().removeChild(m[key])
  END IF

  m[key] = INVALID
END SUB


FUNCTION onKeyEvent(key AS STRING, press AS BOOLEAN) AS BOOLEAN
  handled = false

  IF m.loaded
    IF press
      IF "back" = key AND INVALID <> m.currentExampleScreen
        removeReference(m.currentExampleScreen)
        m.MainView.visible = true
        m.RedditList.setFocus(true)
        handled = true
      ELSE IF "down" = key AND m.RedditList.isInFocusChain()
        m.ExampleList.setFocus(true)
        handled = true
      ELSE IF "up" = key AND m.ExampleList.isInFocusChain()
        m.RedditList.setFocus(true)
        handled = true
      END IF
    END IF
  ELSE
    handled = true
  END IF

  RETURN handled
END FUNCTION