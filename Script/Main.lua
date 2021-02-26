-- package.path = "./Script/?.ES;./Archive/?.data"
package.path = "./Script/?.lua;./Archive/?.data"

SceneManager = require("SceneManager")
ArchiveManager = require("ArchiveManager")

ArchiveManager.OpenArchive("archive")
ArchiveManager.SelectTable("main_table")
SceneManager.Init()

LeadingScene = require("LeadingScene")
BattleScene_Normal = require("BattleScene_Normal")
BattleScene_Hard = require("BattleScene_Hard")
FailureScene = require("FailureScene")
VictoryScene = require("VictoryScene")
SceneManager.AddScene(LeadingScene)
SceneManager.AddScene(BattleScene_Normal)
SceneManager.AddScene(BattleScene_Hard)
SceneManager.AddScene(FailureScene)
SceneManager.AddScene(VictoryScene)

SceneManager.SetStartScene(LeadingScene)

QuitHandler = require("QuitHandler")
SceneManager.SetQuitHandler(QuitHandler.Entry)

SceneManager.Mainloop()