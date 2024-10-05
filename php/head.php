<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><?php echo $title; ?></title>
<meta name="description" content="<?php echo $description; ?>">

<script src="//www.multisitemap.com/valid-links.js"></script>

<style>
    body, html {
        height: 100%;
        margin: 0;
        /*background-color: #e9ecef;*/
        font-family: 'Open Sans', Arial, sans-serif;
        font-size: 16px;
        line-height: 1.6;
        /*color: #333; !* Dark grey color *!*/
        /*background-color: #fff; !* White background *!*/
        margin: 0;
        padding: 0;
    }


    .tophead, .content, .footer {
        display: flex;
        justify-content: center;
        align-items: center;
        padding-top: 5px;
        padding-bottom: 20px;
        text-align: center;
    }

    .tophead {
        background-color: black;
        color: white;
    }
    .tophead h1 {
        margin: 0.5em 0 0em;
    }
    .content {
        background-color: #ffffff;
        width: 100%;
    }

    .markdown {
        background-color: #ffffff;
        justify-content: center;
        align-items: center;
        padding-top: 10px;
        padding-bottom: 30px;
        text-align: left;
        min-width: 600px;
        width: 60%;
    }

    .footer {
        background-color: #f8f9fa;
    }

    form {
        background-color: white;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        min-width: 400px;
        /*width: 90%;*/
    }

    .form-group {
        margin-bottom: 15px;
        display: flex;
        flex-direction: column;
        align-items: flex-start;
    }

    .form-group label {
        margin-bottom: 5px;
        font-weight: bold;
    }

    .form-group input,
    .form-group textarea {
        width: 98%;
        padding: 5px;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-size: 16px;
    }

    .form-group textarea {
        resize: vertical;
    }

    .submit-button, /* Użycie wspólnej klasy dla stylowania */
    input[type=submit],
    button {
        width: 99%;
        padding: 15px;
        background-color: #007bff;
        border: none;
        border-radius: 4px;
        color: white;
        font-size: 19px;
        cursor: pointer;
        transition: background-color 0.2s;
    }

    .submit-button:hover, /* Styl dla wersji hover */
    input[type=submit],
    button:hover {
        background-color: #0056b3;
    }


    h1, h2, h3, h4, h5, h6 {
        font-family: 'Roboto', Arial, sans-serif;
        /*color: #222; !* Slightly darker for headings *!*/
        margin: 1.5em 0 0.5em;
    }
    h2, h3, h4, h5, h6 {
        color: #222; /* Slightly darker for headings */
    }

    p {
        margin: 1em 0;
        letter-spacing: 0.05em;
    }

    a {
        color: #1e90ff;
        text-decoration: none;
    }

    a:hover {
        text-decoration: underline;
    }

    .container {
        max-width: 800px;
        margin: 0 auto;
        padding: 20px;
    }
</style>