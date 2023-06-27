package hello

import "github.com/gin-gonic/gin"

func (hello *HelloerController) Greet(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "hello world!",
	})
}
