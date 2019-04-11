SUB init()

  ' Example of using update to create a children nodes by passing an array
  ' of objects with subtypes and also nested children by leveraging the children field as an array.
  ' The true flag is require when you want to use update to add fields
  ' That don't exist or create children
  m.top.update(m.global.configs.Modules.RowListItem.initConfig)

  ' Here is an example of the object that is being used
  ' [{
  '   subType: "Poster"
  '   id: "itemPoster"
  '   translation: [ 10, 10 ]
  '   width: 512
  '   height: 288
  '   scaleRotateCenter: [ 256.0, 144.0 ]
  '   children: [{
  '       subtype: "Rectangle"
  '       id: "itemMask"
  '       color: "#000000FF"
  '       opacity: 0.75
  '       width: 512
  '       height: 288
  '       scaleRotateCenter: [ 256.0, 144.0 ]
  '     }]
  '   }, {
  '     subtype: "Label"
  '     id: "itemLabel"
  '     translation: [ 20, 20 ]
  '     width: 492
  '     height: 248
  '     wrap: true
  ' }]


  m.itemPoster = m.top.findNode("itemPoster")
  m.itemMask = m.top.findNode("itemMask")
  m.itemLabel = m.top.findNode("itemLabel")
END SUB


SUB showContent(event)
  itemContent = event.getData()

  IF INVALID <> itemContent
    data = itemContent.data

    uri = ""
    IF INVALID <> data.thumbnail AND "self" <> data.thumbnail
      uri = data.thumbnail
    END IF

    m.itemPoster.uri = uri
    m.itemLabel.text = data.title
  END IF
END SUB


SUB showFocus(event)
  scale = 1 + (event.getData() * 0.08)
  m.itemPoster.scale = [scale, scale]
END SUB


SUB onItemHasFocus(event)
  if true = event.getData()
    m.itemPoster.scale = [1.08, 1.08]
  else
    m.itemPoster.scale = [1, 1]
  end if
END SUB
