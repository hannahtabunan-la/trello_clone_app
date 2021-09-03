# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Backend.Repo.insert!(%Backend.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


alias Backend.Repo
alias Backend.Schemas.User
alias Backend.Schemas.Board
alias Backend.Schemas.Permission
alias Backend.Schemas.Task

# insert default user
Repo.insert!(%User{email: "hannah.tabunan@lawadvisor.com", name: "hannah", password: "palindrome"})

# Repo.insert!(%Board{name: "The Carrot Chronicles", user_id: 1})

# Repo.insert!(%Permission{type: "manage", user_id: 1, board_id: 1})

# insert default user
# Repo.insert!(%Task{title: "Look for the Carrots", status: "in_progress", user_id: 1, board_id: 1})
# Repo.insert!(%Task{title: "Buy the Carrots", status: "in_progress", user_id: 1, board_id: 1})
# Repo.insert!(%Task{title: "Journey with the Carrots", status: "in_progress", user_id: 1, board_id: 1})
