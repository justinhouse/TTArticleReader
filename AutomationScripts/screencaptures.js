
var target = UIATarget.localTarget();

target.delay(1);
target.captureScreenWithName("ArticleListScreen")
target.delay(1);

target.frontMostApp().mainWindow().tableViews()[0].tapWithOptions({tapOffset:{x:0.35, y:0.15}});
target.delay(1);

target.captureScreenWithName("ArticleDetailScreen_01")
target.delay(1);

target.frontMostApp().navigationBar().leftButton().tap();
target.delay(1);

target.captureScreenWithName("ArticleDetailScreen_02")
target.delay(1);

target.frontMostApp().navigationBar().leftButton().tap();
target.delay(1);

target.frontMostApp().mainWindow().tableViews()[0].tapWithOptions({tapOffset:{x:0.47, y:0.52}});
target.delay(1);

target.frontMostApp().navigationBar().leftButton().tap();


