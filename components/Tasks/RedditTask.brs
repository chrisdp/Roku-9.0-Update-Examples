FUNCTION init()
  m.top.functionName = "executeTask"
END FUNCTION


FUNCTION executeTask()
  requests = [
    "https://www.reddit.com/r/roku.json",
    "https://www.reddit.com/r/RokuDev.json"
  ]
  rows = []

  FOR EACH url in requests
    request = CreateUrlTransfer(url)
    response = request.GetToString()
    json = ParseJSON(response)
    rows.push(processRowData(json.data))
  END FOR

  contentRoot = CreateObject("RoSGNode", "ContentNode")

  ' Using update we change the feed responses into Content Nodes
  contentRoot.update(rows, true)

  'Now that we have retrieved the data pass it back to the render thread
  m.top.response = contentRoot
END FUNCTION


FUNCTION processRowData(rowData)
  ' Add the subtype so this can be changed to that node type later
  rowData.subtype = "ContentNode"
  rowData.title = "r/" + rowData.children[0].data.subReddit

  FOR i=0 TO rowData.children.Count() - 1
    ' Add the subtype so this can be changed to that node type later
    rowData.children[i].subtype = "ContentNode"
    rowData.children[i].data.subtype = "Node"
  END FOR

  RETURN rowData
END FUNCTION


FUNCTION CreateUrlTransfer(url AS STRING) AS OBJECT
  obj = CreateObject("roUrlTransfer")
  obj.SetCertificatesFile("common:/certs/ca-bundle.crt")
  obj.InitClientCertificates()
  obj.SetPort(CreateObject("roMessagePort"))
  obj.SetUrl(url)
  obj.AddHeader("x-roku-reserved-dev-id","dynamicValueToBeInserted")
  obj.EnableEncodings(true)
  obj.RetainBodyOnError(true)
  RETURN obj
END FUNCTION
