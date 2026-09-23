package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

var pingCmd = &cobra.Command{
	Use:   "ping",
	Short: "Check that the CLI is responsive",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("pong")
	},
}

func init() {
	rootCmd.AddCommand(pingCmd)
}
