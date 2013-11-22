$(document).ready ->
  $("form").submit (e) -> e.preventDefault()
  
  setErrorMessage = (err) -> $('#error').text err

  @checkForm = ->
    username = $('#username').text()
    password = $('#password').text()

    if not username?
      setErrorMessage 'please enter a username'
    else if not password?
      setErrorMessage 'password cannot be blank'
    else if password.length < 12
      setErrorMessage 'password must be longer'
    else if password.length > 12
      setErrorMessage 'password must be shorter'
    else if not /[A-Z]/.test password
      setErrorMessage 'password must contain a capital letter'
    else if password.replace(/[^A-Z]/g, "").length > 1
      setErrorMessage 'password must contain only one capital letter'
    else if not /[A-Z]/.test password[0]
      setErrorMessage 'password must start with a capital letter'
    else if not /[0-9]/.test password
      setErrorMessage 'password must contain a number'
    else if password.replace(/[^0-9]/g, "").length < 4
      setErrorMessage 'password must contain more numbers'
    else if password.replace(/[^0-9]/g, "").length > 4
      setErrorMessage 'password must contain less numbers'
    else if not /[0-9]/.test password[password.length-1]
      setErrorMessage 'password must end with a number'
    else if $('body').attr('style').indexOf("background-color") < 0
      setErrorMessage 'maybe a soothing color will make it easier to pick a better password'
      $('body').animate { backgroundColor: "#ADD8E6" }, "slow"
    else if not $('#bird')[0]?
      setErrorMessage 'hmm, looks like that did not help at all, how about a bird?'
      $('body').prepend('<img id="bird" src="bird.gif" />')