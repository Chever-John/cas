package apiserver

import (
	"github.com/Chever-John/Chever-Apiserver/internal/apiserver/controller/v1/hello"
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
		// user RESTful resource
		userv1 := v1.Group("/users")
		{
			userController := user.NewUserController(storeIns)

		}

		helloerv1 := v1.Group("/helloer")
		{
			helloerController := hello.
		}

		v1.Use(auto.AuthFunc())

		// policy RESTful resource
		policyv1 := v1.Group("/policies", middleware.Publish())
		{
			policyController := policy.NewPolicyController(storeIns)

			policyv1.POST("", policyController.Create)
			policyv1.DELETE("", policyController.DeleteCollection)
			policyv1.DELETE(":name", policyController.Delete)
			policyv1.PUT(":name", policyController.Update)
			policyv1.GET("", policyController.List)
			policyv1.GET(":name", policyController.Get)
		}

		// secret RESTful resource
		secretv1 := v1.Group("/secrets", middleware.Publish())
		{
			secretController := secret.NewSecretController(storeIns)

			secretv1.POST("", secretController.Create)
			secretv1.DELETE(":name", secretController.Delete)
			secretv1.PUT(":name", secretController.Update)
			secretv1.GET("", secretController.List)
			secretv1.GET(":name", secretController.Get)
		}
	}

	return g
}
