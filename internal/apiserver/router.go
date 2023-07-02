package apiserver

import (
	"github.com/Chever-John/cas/internal/apiserver/controller/v1/hello"
	"github.com/gin-gonic/gin"
)

func initRouter(g *gin.Engine) {
	installMiddleware(g)
	installController(g)
}

func installMiddleware(g *gin.Engine) {
}

func installController(g *gin.Engine) *gin.Engine {
	// v1 handlers, requiring authentication
	v1 := g.Group("/v1")
	{
		// helloer RESTful resource
		helloerv1 := v1.Group("/helloers")
		{
			helloerController := hello.NewHelloerController()

			helloerv1.GET("", helloerController.Greet)
		}

	}

	return g
}
